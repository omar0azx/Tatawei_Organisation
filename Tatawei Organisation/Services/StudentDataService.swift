//
//  StudentDataService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 18/05/1446 AH.
//

import Foundation
import FirebaseFirestore

class StudentDataService {
    
    static let shared = StudentDataService()
    
    private let db = Firestore.firestore()
    
    func getStudentIDs(organisationID: String, opportunityID: String, acceptanceStudents: Bool, completion: @escaping (_ studentIDs: [String]) -> Void) {
        let studentOpportunityRef = FirestoreReference(.organisations)
            .document(organisationID)
            .collection("opportunities")
            .document(opportunityID)
            .collection("studentOpportunity")
            .whereField("isAccepted", isEqualTo: acceptanceStudents) // Use the acceptanceStudents parameter directly

        studentOpportunityRef.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error retrieving student opportunity data: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            var studentIDs = [String]()

            for document in documents {
                // Collect the document ID as the student ID
                studentIDs.append(document.documentID)
            }
            completion(studentIDs)
        }
    }

    func getStudentByID(studentID: String, completion: @escaping (Student?, Error?) -> Void) {
        
        // Query for a student by ID across all "students" collections
        db.collectionGroup("students").whereField("id", isEqualTo: studentID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else if let document = snapshot?.documents.first {
                let studentData = document.data()
                
                // Convert Firestore data to JSON Data
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: studentData, options: [])
                    
                    // Decode JSON data to Student object
                    let decoder = JSONDecoder()
                    let student = try decoder.decode(Student.self, from: jsonData)
                    completion(student, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, nil)  // Student not found
            }
        }
    }


    
    func getStudentsForAttendance(organisationID: String, opportunityID: String, completion: @escaping (_ error: Error?) -> Void) {

        getStudentIDs(organisationID: organisationID, opportunityID: opportunityID, acceptanceStudents: true) { studentIDs in
            guard !studentIDs.isEmpty else {
                completion(("No student IDs found or all students are accepted" as? Error)) // No error, just no students
                return
            }
            
            // Iterate through the studentIDs and fetch their information using collectionGroup
            let query = self.db.collectionGroup("students")
                .whereField("id", in: studentIDs) // Filter by studentIDs
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching students: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                
                var students = [Student]() // Create an empty array to store Student objects
                
                // Iterate through the query snapshot to extract student information
                snapshot?.documents.forEach { document in
                    // Directly access the data dictionary
                    let data = document.data()
                    
                    // Check if 'name' field exists and is a String
                    if let name = data["name"] as? String, let gender = data["gender"] as? String, let level = data["level"] as? String {
                        // Create Student object
                        var student = Student(id: document.documentID, name: name, level: level, gender: Gender(rawValue: gender) ?? .male)
                        student.isAttended = false
                        print("student ->>> \(student)")
                        students.append(student)
                    }
                }
                // Save to local Realm storage
                if !students.isEmpty {
                    StudentRealmService.shared.saveStudentsForOpportunity(opportunityID: opportunityID, students: students)
                }
                
                completion(nil) // Indicate success
            }
        }
    }
    
    func getStudentsForAcceptance(organisationID: String, opportunityID: String, completion: @escaping (_ error: Error?, _ students: [Student]) -> Void) {
        
        getStudentIDs(organisationID: organisationID, opportunityID: opportunityID, acceptanceStudents: false) { studentIDs in
            guard !studentIDs.isEmpty else {
                completion(("No student IDs found or all students are accepted" as? Error), []) // No error, just no students
                return
            }
            
            // Iterate through the studentIDs and fetch their information using collectionGroup
            let query = self.db.collectionGroup("students")
                .whereField("id", in: studentIDs) // Filter by studentIDs
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching students: \(error.localizedDescription)")
                    completion(error, [])
                    return
                }
                
                var students = [Student]() // Create an empty array to store Student objects
                
                // Iterate through the query snapshot to extract student information
                snapshot?.documents.forEach { document in
                    // Directly access the data dictionary
                    let data = document.data()
                    
                    if let name = data["name"] as? String, let phoneNumber = data["phoneNumber"] as? String, let level = data["level"] as? String, let opportinities = data["opportunities"] as? [String: Bool], let hoursCompleted = data["hoursCompleted"] as? Int, let gender = data["gender"] as? String {
                        // Create Student object

                        
                        let student = Student(id: document.documentID, name: name, phoneNumber: phoneNumber, level: level, opportinitiesNumber: opportinities.filter{$0.value == true}.count, hoursCompleted: hoursCompleted, gender: Gender(rawValue: gender) ?? .male)
                        students.append(student)
                    }
                }

                completion(nil, students) // Indicate success
            }
        }
    }
    
    func updateStudentsAttended(opportunityID: String, studentIDs: [String], completion: @escaping (_ error: Error?) -> Void) {
        // Reference to the Firestore collection
        let studentOpportunitiesRef = FirestoreReference(.organisations)
            .document(Organization.currentOrganization!.id)
            .collection("opportunities").document(opportunityID).collection("studentOpportunity")
        
        // Group for managing multiple async tasks
        let dispatchGroup = DispatchGroup()
        
        for studentID in studentIDs {
            // Enter the group for each Firestore operation
            dispatchGroup.enter()
            
            // Reference the specific document for the student ID
            let studentRef = studentOpportunitiesRef.document(studentID)
            
            // Update the `isAccepted` field to true
            studentRef.updateData(["isAttended": true]) { error in
                if let error = error {
                    print("Error updating isAttended for \(studentID): \(error.localizedDescription)")
                } else {
                    print("Successfully updated isAttended for \(studentID).")
                }
                // Leave the group after the operation completes
                dispatchGroup.leave()
            }
        }
        
        // Notify when all updates are completed
        dispatchGroup.notify(queue: .main) {
            completion(nil) // Indicate success
        }
    }
    
    func updateStudentsAcceptance(opportunityID: String, studentIDs: [String], completion: @escaping (_ error: Error?) -> Void) {
        // Reference to the Firestore collection
        let studentOpportunitiesRef = FirestoreReference(.organisations)
            .document(Organization.currentOrganization!.id)
            .collection("opportunities").document(opportunityID).collection("studentOpportunity")
        
        // Group for managing multiple async tasks
        let dispatchGroup = DispatchGroup()
        
        for studentID in studentIDs {
            // Enter the group for each Firestore operation
            dispatchGroup.enter()
            
            // Reference the specific document for the student ID
            let studentRef = studentOpportunitiesRef.document(studentID)
            
            // Update the `isAccepted` field to true
            studentRef.updateData(["isAccepted": true]) { error in
                if let error = error {
                    print("Error updating isAccepted for \(studentID): \(error.localizedDescription)")
                } else {
                    print("Successfully updated isAccepted for \(studentID).")
                }
                // Leave the group after the operation completes
                dispatchGroup.leave()
            }
        }
        
        // Notify when all updates are completed
        dispatchGroup.notify(queue: .main) {
            completion(nil) // Indicate success
        }
    }
    
    
    func incrementBadges(studentID: String, selectedBadges: [SkillsBadges], completion: @escaping (Bool, Error?) -> Void) {
        
        // Ensure that the selected badges array contains no more than 3 badges
        guard selectedBadges.count <= 3 else {
            completion(false, NSError(domain: "Badges Error", code: 400, userInfo: [NSLocalizedDescriptionKey: "You can only select a maximum of 3 badges."]))
            return
        }
        
        // Fetch the student's document
        db.collectionGroup("students").whereField("id", isEqualTo: studentID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, error)
            } else if let document = snapshot?.documents.first {
                var studentData = document.data()
                
                // Retrieve existing badge data (if any)
                var badges = studentData["badges"] as? [String: Int] ?? [:]
                
                // Increment the badge counts
                for badge in selectedBadges {
                    let badgeKey = badge.rawValue
                    let currentCount = badges[badgeKey] ?? 0
                    badges[badgeKey] = currentCount + 1
                }
                
                // Update the Firestore document with the new badge counts
                studentData["badges"] = badges
                document.reference.updateData(studentData) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            } else {
                completion(false, NSError(domain: "Firestore Error", code: 404, userInfo: [NSLocalizedDescriptionKey: "Student not found."]))
            }
        }
    }
    
}

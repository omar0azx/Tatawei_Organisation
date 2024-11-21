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
            .collection("studentOpportunity").whereField("isAccepted", isEqualTo: acceptanceStudents)
        
        studentOpportunityRef.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error retrieving student opportunity data: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            var studentIDs = [String]()
            
            for document in documents {
                let data = document.data()
                
                // Assuming each document has fields 'studentID' and 'isAccepted'
                if let isAccepted = data["isAccepted"] as? Bool, !isAccepted {
                    studentIDs.append(document.documentID) // Use document ID as student ID
                }
            }
            completion(studentIDs)
        }
    }
    
    func getStudentsForAttendance(organisationID: String, opportunityID: String, completion: @escaping (_ error: Error?) -> Void) {

        getStudentIDs(organisationID: organisationID, opportunityID: opportunityID, acceptanceStudents: false) { studentIDs in
            guard !studentIDs.isEmpty else {
                print("No student IDs found or all students are accepted.")
                completion(nil) // No error, just no students
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
                    if let name = data["name"] as? String {
                        // Create Student object
                        var student = Student(id: document.documentID, name: name, gender: .male)
                        student.isAttended = false
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
    
//    func getStudentsForAcceptance(organisationID: String, opportunityID: String, completion: @escaping (_ error: Error?, _ students: [Student]) -> Void) {
//        
//        getStudentIDs(organisationID: organisationID, opportunityID: opportunityID, acceptanceStudents: false) { studentIDs in
//            guard !studentIDs.isEmpty else {
//                completion(("No student IDs found or all students are accepted" as! Error), []) // No error, just no students
//                return
//            }
//            
//            // Iterate through the studentIDs and fetch their information using collectionGroup
//            let query = self.db.collectionGroup("students")
//                .whereField("id", in: studentIDs) // Filter by studentIDs
//            
//            query.getDocuments { (snapshot, error) in
//                if let error = error {
//                    print("Error fetching students: \(error.localizedDescription)")
//                    completion(error, [])
//                    return
//                }
//                
//                var students = [Student]() // Create an empty array to store Student objects
//                
//                // Iterate through the query snapshot to extract student information
//                snapshot?.documents.forEach { document in
//                    // Directly access the data dictionary
//                    let data = document.data()
//                    
//                    // Check if 'name' field exists and is a String
//                    if let name = data["name"] as? String {
//                        // Create Student object
//                        let student = Student(id: document.documentID, name: name, gender: .male)
//                        students.append(student)
//                    }
//                }
//                
//                completion(nil, students) // Indicate success
//            }
//        }
//    }
    
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

    
}

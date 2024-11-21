//
//  StudentRealmService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 17/05/1446 AH.
//

import Foundation
import RealmSwift

class StudentRealmService {
    
    static let shared = StudentRealmService()
    private let studentRealm: Realm
    
    
    private init() {
        do {
            self.studentRealm = try Realm() // Initialize Realm
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    
    // Helper function to generate unique student ID
    func getStudentUniqueID(studentID: String, opportunityID: String) -> String {
        return studentID + opportunityID
    }

    func saveStudentsForOpportunity(opportunityID: String, students: [Student]) {
        do {
            try studentRealm.write {
                // Fetch or create OpportunityStudentsObject for this opportunity
                let opportunityStudentsObject: OpportunityStudentsObject
                
                if let existingOpportunity = studentRealm.object(ofType: OpportunityStudentsObject.self, forPrimaryKey: opportunityID) {
                    opportunityStudentsObject = existingOpportunity
                } else {
                    opportunityStudentsObject = OpportunityStudentsObject()
                    opportunityStudentsObject.opportunityID = opportunityID
                    studentRealm.add(opportunityStudentsObject)
                }
                
                // Loop through the students and add or update them as necessary
                for student in students {
                    let studentID = student.id
                    let uniqueID = studentID + opportunityID // Concatenate studentID and opportunityID once
                    
                    // Debugging: Print the concatenated ID
                    print("Saving student with ID: \(uniqueID) for opportunity: \(opportunityID)")
                    
                    // Check if the student already exists with the unique ID
                    if let existingStudent = studentRealm.object(ofType: StudentObject.self, forPrimaryKey: uniqueID) {
                        // If student exists, check if the name has changed
                        if existingStudent.name != student.name {
                            existingStudent.name = student.name // Update the name if changed
                            print("Updated student: \(existingStudent)")
                        }
                    } else {
                        // If student doesn't exist, create a new StudentObject
                        var studentObject = student.toRealmObject()
                        studentObject.id = uniqueID // Ensure the ID is concatenated correctly
                        studentRealm.add(studentObject) // Add the new student
                        opportunityStudentsObject.students.append(studentObject) // Add to opportunity's students list
                        print("Added new student: \(studentObject)")
                    }
                }
                
                // Add or update the OpportunityStudentsObject in Realm
                studentRealm.add(opportunityStudentsObject, update: .modified)
                print("Saved OpportunityStudentsObject: \(opportunityStudentsObject)")
            }
        } catch {
            print("Error saving students for opportunity: \(error.localizedDescription)")
        }
    }
    
    func getStudentsForOpportunity(opportunityID: String) -> [Student] {
        if let opportunityStudentsObject = studentRealm.object(ofType: OpportunityStudentsObject.self, forPrimaryKey: opportunityID) {
            return opportunityStudentsObject.students.map { $0.toStruct() }
        }
        return []
    }
    
    func getAllStudentIDs() -> [String] {
        let studentObjects = studentRealm.objects(StudentObject.self).filter("isAttended == true")
        return studentObjects.compactMap {
            // Extract the first 28 characters (the studentID) from the student ID
            let studentID = String($0.id.prefix(28)) // Assuming studentID is always the first 28 characters
            return studentID
        }
    }
    
    func getStudentById(opportunityID: String, studentID: String) -> Student? {
        // Concatenate the studentID and opportunityID to create a unique identifier
        let uniqueID = studentID + opportunityID // Concatenate once
        
        // Debugging: Print the unique ID being searched for
        print("Searching for student with ID: \(uniqueID) in opportunity: \(opportunityID)")
        
        // Fetch the OpportunityStudentsObject for the given opportunityID
        guard let opportunityStudentsObject = studentRealm.object(ofType: OpportunityStudentsObject.self, forPrimaryKey: opportunityID) else {
            print("Opportunity with ID \(opportunityID) not found in Realm.")
            return nil
        }
        
        // Search for the student within the opportunity's students list by the concatenated ID
        if let studentObject = opportunityStudentsObject.students.first(where: { $0.id == uniqueID }) {
            return studentObject.toStruct() // Convert to the Student struct and return
        } else {
            print("Student with ID \(uniqueID) not found in opportunity \(opportunityID).")
            return nil
        }
    }

    func updateIsAttendedForStudentInOpportunity(studentID: String, opportunityID: String, isAttended: Bool) {
        do {
            try studentRealm.write {
                
                // Debugging: Print the unique ID being searched for
                print("Updating isAttended for student with ID: \(studentID) in opportunity: \(opportunityID)")
                
                // Fetch the OpportunityStudentsObject for the given opportunityID
                if let opportunity = studentRealm.object(ofType: OpportunityStudentsObject.self, forPrimaryKey: opportunityID) {
                    
                    // Find the student within this opportunity by the concatenated ID
                    if let studentObject = opportunity.students.first(where: { $0.id == studentID }) {
                        
                        // Update the isAttended property for this student
                        studentObject.isAttended = isAttended
                        print("Updated isAttended for student \(studentID) in opportunity \(opportunityID) to \(isAttended)")
                    } else {
                        print("Student with ID \(studentID) not found in opportunity \(opportunityID)")
                    }
                } else {
                    print("Opportunity with ID \(opportunityID) not found.")
                }
            }
        } catch {
            print("Error updating isAttended for student: \(error.localizedDescription)")
        }
    }

    func deleteAllStudentsForOpportunity(opportunityID: String) {
        do {
            try studentRealm.write {
                // Fetch the OpportunityStudentsObject for the given opportunityID
                if let opportunityStudentsObject = studentRealm.object(ofType: OpportunityStudentsObject.self, forPrimaryKey: opportunityID) {
                    // Delete all students in this opportunity
                    studentRealm.delete(opportunityStudentsObject.students)
                    print("Deleted all students for opportunity: \(opportunityID)")
                }
            }
        } catch {
            print("Error deleting all students for opportunity: \(error.localizedDescription)")
        }
    }
    
    func deleteStudentsForOpportunity(opportunityID: String) {
        do {
            try studentRealm.write {
                // Fetch all students whose ID contains the opportunityID part
                let studentsToDelete = studentRealm.objects(StudentObject.self).filter("id CONTAINS[cd] %@", opportunityID)
                
                // Delete the students with matching opportunityID
                studentRealm.delete(studentsToDelete)
                print("Deleted students with opportunityID \(opportunityID)")
            }
        } catch {
            print("Error deleting students for opportunity: \(error.localizedDescription)")
        }
    }

}

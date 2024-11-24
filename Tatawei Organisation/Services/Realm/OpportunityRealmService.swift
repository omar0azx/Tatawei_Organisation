//
//  OpportunityRealmService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 17/05/1446 AH.
//

import Foundation
import RealmSwift

class OpportunityRealmService {
    
    static let shared = OpportunityRealmService()
    private let opportunityRealm: Realm
    
    
    private init() {
        do {
            self.opportunityRealm = try Realm() // Initialize Realm
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    // Save a new opportunity and append it to the local array
    func saveNewOpportunity(_ newOpportunity: Opportunity) {
        let realmObject = newOpportunity.toRealmObject() // Convert Opportunity to Realm object
        
        // Save to Realm
        do {
            try opportunityRealm.write {
                opportunityRealm.add(realmObject, update: .all) // Update if the object already exists
            }
        } catch {
            print("Error saving new opportunity to Realm: \(error.localizedDescription)")
        }
    }
    
    // Get opportunity by ID
    func getOpportunityById(_ id: String) -> Opportunity? {
        guard let realmObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: id) else {
            return nil
        }
        return realmObject.toStruct()
    }
    
    func updateOpportunity(_ updatedOpportunity: Opportunity) {
        // Find and update in Realm
        guard let realmObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: updatedOpportunity.id) else {
            print("Opportunity not found in Realm.")
            return
        }
        
        do {
            try opportunityRealm.write {
                realmObject.name = updatedOpportunity.name
                realmObject.opportunityDescription = updatedOpportunity.description
                realmObject.date = updatedOpportunity.date
                realmObject.time = updatedOpportunity.time
                realmObject.hour = updatedOpportunity.hour
                realmObject.city = updatedOpportunity.city.rawValue
                realmObject.status = updatedOpportunity.status.rawValue
                realmObject.category = updatedOpportunity.category.rawValue
                realmObject.iconNumber = updatedOpportunity.iconNumber
                realmObject.location = updatedOpportunity.location
                realmObject.latitude = updatedOpportunity.latitude
                realmObject.longitude = updatedOpportunity.longitude
                realmObject.studentsNumber = updatedOpportunity.studentsNumber
                realmObject.acceptedStudents = updatedOpportunity.acceptedStudents
                realmObject.organizationID = updatedOpportunity.organizationID
                realmObject.organizationName = updatedOpportunity.organizationName
                realmObject.isStudentsAcceptanceFinished = updatedOpportunity.isStudentsAcceptanceFinished ?? false
            }
        } catch {
            print("Error updating opportunity in Realm: \(error.localizedDescription)")
        }
    }
    
    func updateOpportunityStatusById(_ id: String, status: OpportunityStatus) {
        do {
            guard let opportunityObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: id) else {
                print("Student with ID \(id) not found.")
                return
            }
            
            // Begin a write transaction
            try opportunityRealm.write {
                opportunityObject.status = status.rawValue
                opportunityObject.isStudentsAcceptanceFinished = true
                print("Updated student \(opportunityObject.id)'s attendance to \(status).")
            }
        } catch {
            print("Error updating student's attendance: \(error.localizedDescription)")
        }
    }
    
    func updateOpportunityStudentsNumberById(_ id: String, studentsNumber: Int) {
        do {
            guard let opportunityObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: id) else {
                print("Student with ID \(id) not found.")
                return
            }
            
            // Begin a write transaction
            try opportunityRealm.write {
                opportunityObject.acceptedStudents = studentsNumber
                print("Updated opportunity \(opportunityObject.id) to \(studentsNumber).")
            }
        } catch {
            print("Error updating opportunity: \(error.localizedDescription)")
        }
    }
    
    func updateOpportunityTest() {
        do {
            guard let opportunityObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: "lSqAorlmrTdBBSUUiLIvIlffkX43") else {
                print("Student with ID i6R5FjkvwfFjgawUVRFj not found.")
                return
            }
            
            // Begin a write transaction
            try opportunityRealm.write {
                opportunityObject.status = "open"
                opportunityObject.date = "01/12/2024"
            }
        } catch {
            print("Error updating student's attendance: \(error.localizedDescription)")
        }
    }
    
    // Delete opportunity by ID
    func deleteOpportunityById(_ id: String) {
        guard let realmObject = opportunityRealm.object(ofType: OpportunityObject.self, forPrimaryKey: id) else {
            return
        }
        do {
            try opportunityRealm.write {
                opportunityRealm.delete(realmObject)
            }
        } catch {
            print("Error deleting opportunity: \(error.localizedDescription)")
        }
    }
    
    func getAllOpportunities() -> [Opportunity] {
        // Fetch all OpportunityObject entries from Realm
        let realmObjects = opportunityRealm.objects(OpportunityObject.self)
        
        // Map Realm objects to Opportunity structs
        return realmObjects.compactMap { $0.toStruct() }
    }

}

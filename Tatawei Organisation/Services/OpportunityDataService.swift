//
//  OpportunityDataService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 14/05/1446 AH.
//

import Foundation
import FirebaseFirestore

class OpportunityDataService {
    
    static let shared = OpportunityDataService()
    
    private let db = Firestore.firestore()
    
    func addNewOpportunity(organisationID: String, name: String, description: String, date: String, time: String, hour: Int, city: Cities, status: OpportunityStatus, category: InterestCategories, iconNumber: Int, location: String, latitude: Double, longitude: Double, studentsNumber: Int, organizationName: String, completion: @escaping (_ status: Bool?, _ error: Error?) -> Void) {
        
        let opportunityRef = FirestoreReference(.organisations).document(organisationID).collection("opportunities").document()
        let generatedID = opportunityRef.documentID // Get the unique document ID

        let newOpportunity = Opportunity(id: generatedID, name: name, description: description, date: date, time: time, hour: hour, city: city, status: status, category: category, iconNumber: iconNumber, location: location, latitude: latitude, longitude: longitude, studentsNumber: studentsNumber, organizationID: organisationID, organizationName: organizationName)
        
        do {
            try opportunityRef.setData(from: newOpportunity) { error in
                if let error = error {
                    print("Error adding opportunity: \(error.localizedDescription)")
                    completion(false, error)
                    return
                }
                print("Opportunity added successfully!")
                var myOpportunity = newOpportunity
                myOpportunity.isStudentsAcceptanceFinished = false
                OpportunityRealmService.shared.saveNewOpportunity(myOpportunity)
                completion(true, nil)
            }
        } catch {
            print("Failed to set data for opportunity: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func updateOpportunity(updatedData: Opportunity, completion: @escaping (_ error: Error?) -> Void) {
        // Get reference to the opportunity's document in Firestore
        let opportunityRef = FirestoreReference(.organisations).document(Organization.currentOrganization!.id)
            .collection("opportunities").document(updatedData.id)
        
        opportunityRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.data() != nil{
                    
                    let updatedOpportunity = updatedData
                    
                    // Convert updatedOpportunity to a dictionary using JSONEncoder
                    do {
                        let jsonData = try JSONEncoder().encode(updatedOpportunity)
                        if let updatedOpportunityDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                            // Update Firestore with the new values
                            opportunityRef.updateData(updatedOpportunityDict) { error in
                                if let error = error {
                                    print("Error updating opportunity data: \(error.localizedDescription)")
                                    completion(error)
                                } else {
                                    OpportunityRealmService.shared.updateOpportunity(updatedOpportunity)
                                    print("Opportunity data successfully updated.")
                                    completion(nil)
                                }
                            }
                        }
                    } catch {
                        print("Error encoding opportunity data: \(error.localizedDescription)")
                        completion(error)
                    }
                } else {
                    print("Error value: \(error?.localizedDescription ?? "Unknown error")")
                    completion(error)
                }
                
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(error)
            }
        }
    }
    
    func checkAndUpdateOpportunitiesStatus(completion: @escaping (_ error: Error?) -> Void) {

        let opportunities = OpportunityRealmService.shared.getAllOpportunities()
        let todayDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        for opportunity in opportunities {
            if opportunity.date < todayDate {
                self.updateOpportunityStatus(opportunityID: opportunity.id, status: .finished)
            }
        }
        
        completion(nil)
    }

    
    func updateOpportunityStatus(opportunityID: String, status: OpportunityStatus) {
        let opportunityRef = FirestoreReference(.organisations).document(Organization.currentOrganization!.id).collection("opportunities").document(opportunityID)
        
        opportunityRef.updateData([
            "status": status.rawValue
        ]) { error in
            if let error = error {
                print("Error updating opportunity status: \(error.localizedDescription)")
            } else {
                print("Opportunity status updated to \(status)")
                if status == .finished {
                    StudentDataService.shared.updateStudentsAttended(opportunityID: opportunityID, studentIDs: StudentRealmService.shared.getAllStudentIDs()) { error in
                        if let error = error {
                            print("Error updating attended status: \(error.localizedDescription)")
                        } else {
                            StudentRealmService.shared.deleteStudentsForOpportunity(opportunityID: opportunityID)
                        }
                    }
                }
                OpportunityRealmService.shared.updateOpportunityStatusById(opportunityID, status: status)
            }
        }
    }
    
    func deleteOpportunity(opportunityID: String, completion: @escaping (_ error: Error?) -> Void) {
        // Get reference to the opportunity's document in Firestore
        let opportunityRef = FirestoreReference(.organisations).document(Organization.currentOrganization!.id)
            .collection("opportunities").document(opportunityID)
        
        opportunityRef.delete { error in
            if let error = error {
                // Handle the error
                print("Error deleting opportunity: \(error.localizedDescription)")
                completion(error)
            } else {
                // Successfully deleted
                print("Opportunity with ID \(opportunityID) successfully deleted.")
                OpportunityRealmService.shared.deleteOpportunityById(opportunityID)
                completion(nil)
            }
        }
    }
    
}

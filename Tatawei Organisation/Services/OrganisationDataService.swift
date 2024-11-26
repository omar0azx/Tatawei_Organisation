//
//  OrganisationDataService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 23/05/1446 AH.
//


import Foundation
import FirebaseFirestore

class OrganisationDataService {
    
    static let shared = OrganisationDataService()
    
    private let db = Firestore.firestore()
    
    func getOrganisationData(organisationID: String, completion: @escaping (_ status: Bool?, _ error: Error?) -> Void) {
        // Reference to the Firestore collection where organisation are stored
        let organisationRef = FirestoreReference(.organisations).document(organisationID)
        
        organisationRef.getDocument { (document, error) in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(false, nil) // No document found
                return
            }
            
            // Try to decode the document data into a Student struct
            do {
                
                let organisation = try document.data(as: Organization.self)
                
                saveOrganizationLocally(organisation)
                print("organisation found and saved locally: organisation")
                
                completion(true, nil)
                
            } catch {
                
                print("Error decoding organisation data: \(error.localizedDescription)")
                
                completion(false, error)
            }
        }
    }
    
    func addNumbersForOrganisation(opportunitiesNumberToAdd: Int, opportunitiesHoursToAdd: Int, volunteersNumberToAdd: Int, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let documentRef = FirestoreReference(.organisations).document(Organization.currentOrganization?.id ?? "123")

        // Retrieve the current values
        documentRef.getDocument { (document, error) in
            if let error = error {
                completion(false, error)
                return
            }

            guard let document = document, document.exists else {
                completion(false, NSError(domain: "Firestore Error", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found."]))
                return
            }

            // Retrieve current values or default to 0 if they don't exist
            let currentOpportunitiesNumber = document.data()?["opportunitiesNumber"] as? Int ?? 0
            let currentVolunteersNumber = document.data()?["volunteersNumber"] as? Int ?? 0
            let completedOpportunitesHours = document.data()?["completedOpportunitesHours"] as? Int ?? 0

            // Calculate the new values
            let newOpportunitiesNumber = currentOpportunitiesNumber + opportunitiesNumberToAdd
            let newVolunteersNumber = currentVolunteersNumber + volunteersNumberToAdd
            let newHours = completedOpportunitesHours + opportunitiesHoursToAdd

            // Update all fields at once
            documentRef.updateData([
                "opportunitiesNumber": newOpportunitiesNumber,
                "volunteersNumber": newVolunteersNumber,
                "completedOpportunitesHours": newHours
            ]) { error in
                if let error = error {
                    completion(false, error) // Error updating fields
                } else {
                    // Safely attempt to decode the organization
                    if let organisation = try? document.data(as: Organization.self) {
                        saveOrganizationLocally(organisation)
                    }
                    completion(true, nil) // Successfully updated fields
                }
            }
        }
    }

}

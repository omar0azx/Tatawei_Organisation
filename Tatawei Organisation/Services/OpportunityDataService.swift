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
                completion(true, nil)
            }
        } catch {
            print("Failed to set data for opportunity: \(error.localizedDescription)")
            completion(false, error)
        }
    }
}

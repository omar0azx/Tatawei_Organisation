//
//  OfficialDataService.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 09/05/1446 AH.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case schools
    case students
    case organisations
    case opportunities
}



func FirestoreReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

class OfficialDataService {
    
    static let shared = OfficialDataService()
    
    private let db = Firestore.firestore()
    
    func addOrganisationWithOfficial(organisation: Organization, official: Official) {
        let organisationDoc = FirestoreReference(.organisations).document(organisation.id)
        
        do {
            try organisationDoc.setData(from: organisation) { error in
                if let error = error {
                    print("Error adding organisation: \(error.localizedDescription)")
                    return
                }
                
                // If successful, add the official to the OrganisationOfficials sub-collection
                let officialsRef = organisationDoc.collection("organisationOfficials")
                
                do {
                    try officialsRef.document(official.id).setData(from: official) { error in
                        if let error = error {
                            print("Error adding organisation official: \(error.localizedDescription)")
                        } else {
                            print("Organisation and official added successfully!")
                        }
                    }
                } catch {
                    print("Failed to set data for official: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Failed to set data for organisation: \(error.localizedDescription)")
        }
    }
    
    func addOfficialToOrganisation(organisationID: String, official: Official) {
        let organisationDoc = FirestoreReference(.organisations).document(organisationID)
        
        
        // If successful, add the official to the OrganisationOfficials sub-collection
        let officialsRef = organisationDoc.collection("organisationOfficials")
        
        do {
            try officialsRef.document(official.id).setData(from: official) { error in
                if let error = error {
                    print("Error adding organisation official: \(error.localizedDescription)")
                } else {
                    self.getOrganisationData(organisationID: organisationID) { status, error in
                        if error != nil {
                            print("Organisation and official added successfully!")
                        }
                    }
                }
            }
        } catch {
            print("Failed to set data for official: \(error.localizedDescription)")
        }
    }
    
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
        
        // MARK: - Download User from Firestore
        
        func getOfficialDataIfExists(withID officialID: String, completion: @escaping (_ exists: Bool, _ organisationOfficial: Official?) -> ()) {
            // Create a query to search for the document by its ID within the collection group
            let query = db.collectionGroup("organisationOfficials").whereField("id", isEqualTo: officialID)
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching data for OfficialID: \(error.localizedDescription)")
                    completion(false, nil)
                    return
                }
                
                // Check if we received any documents
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("Official with ID \(officialID) not found.")
                    completion(false, nil)
                    return
                }
                
                // Get the data from the first document (assuming `officialID` is unique within the collection group)
                let documentData = documents[0].data()
                print("Official with ID \(officialID) found with data: \(documentData)")
                
                // Convert the document data to JSON data
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
                    
                    // Decode the JSON data into an OrganisationOfficial object
                    let decoder = JSONDecoder()
                    let organisationOfficial = try decoder.decode(Official.self, from: jsonData)
                    
                    completion(true, organisationOfficial)
                } catch {
                    print("Error decoding official data: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
        }
        
        func updatedOfficialAccount(updatedData: Official, completion: @escaping (_ error: Error?) -> Void) {
            // Get reference to the official's document in Firestore
            let officialRef = FirestoreReference(.organisations).document(updatedData.organizationID)
                .collection("organisationOfficials").document(Official.currentID)
            
            officialRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if document.data() != nil {
                        
                        let updatedOfficial = updatedData
                        
                        // Convert updatedOfficial to a dictionary using JSONEncoder
                        do {
                            let jsonData = try JSONEncoder().encode(updatedOfficial)
                            if let updatedOfficialDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                                // Update Firestore with the new values
                                officialRef.updateData(updatedOfficialDict) { error in
                                    if let error = error {
                                        print("Error updating official data: \(error.localizedDescription)")
                                        completion(error)
                                    } else {
                                        
                                        saveUserLocally(updatedOfficial)
                                        print("Official data successfully updated.")
                                        completion(nil)
                                    }
                                }
                            }
                        } catch {
                            print("Error encoding student data: \(error.localizedDescription)")
                            completion(error)
                        }
                    } else {
                        print("Error fetching hoursCompleted value: \(error?.localizedDescription ?? "Unknown error")")
                        completion(error)
                    }
                    
                } else {
                    print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                    completion(error)
                }
            }
        }
        
        func updatedOrganisationAccount(updatedData: Organization, organizationID: String, completion: @escaping (_ error: Error?) -> Void) {
            // Get reference to the organization's document in Firestore
            let organisationsRef = FirestoreReference(.organisations).document(organizationID)
            
            organisationsRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let numberOfReviewers = data["numberOfReviewers"] as? Int, let opportunitiesNumber = data["opportunitiesNumber"] as? Int, let rate = data["rate"] as? Double, let volunteersNumber = data["volunteersNumber"] as? Int {
                        
                        var updatedOrganization = updatedData
                        updatedOrganization.numberOfReviewers = numberOfReviewers
                        updatedOrganization.opportunitiesNumber = opportunitiesNumber
                        updatedOrganization.rate = rate
                        updatedOrganization.volunteersNumber = volunteersNumber
                        
                        // Convert updatedOrganization to a dictionary using JSONEncoder
                        do {
                            let jsonData = try JSONEncoder().encode(updatedOrganization)
                            if let updatedOfficialDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                                // Update Firestore with the new values
                                organisationsRef.updateData(updatedOfficialDict) { error in
                                    if let error = error {
                                        print("Error updating Organization data: \(error.localizedDescription)")
                                        completion(error)
                                    } else {
                                        
                                        saveOrganizationLocally(updatedOrganization)
                                        print("Organization data successfully updated.")
                                        completion(nil)
                                    }
                                }
                            }
                        } catch {
                            print("Error encoding student data: \(error.localizedDescription)")
                            completion(error)
                        }
                    } else {
                        print("Error fetching hoursCompleted value: \(error?.localizedDescription ?? "Unknown error")")
                        completion(error)
                    }
                    
                } else {
                    print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                    completion(error)
                }
            }
        }
    
    //MARK:- Download all official for organisation
    func getAllOfficialsFromOrganisation(organisationID: String, completion: @escaping (_ allUsers: [Official], _ error: Error?)->Void) {
        var users: [Official] = []
        
        FirestoreReference(.organisations).document(organisationID).collection("organisationOfficials").getDocuments { (snapshot, error) in
            // Handle error case
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                completion([], error) // Return an empty array on error
                return
            }
            
            // Guard against empty snapshot
            guard let documents = snapshot?.documents else {
                print("No documents found")
                completion([], error) // Return an empty array if no documents exist
                return
            }
            
            // Parse all users and filter out the current student
            let allUsers = documents.compactMap { (snapshot) -> Official? in
                return try? snapshot.data(as: Official.self)
            }
            
            users.append(contentsOf: allUsers)
            
            
            // Completion handler with filtered list of users
            completion(users, nil)
        }
    }
    
}


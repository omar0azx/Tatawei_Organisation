//
//  AuthServices.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 23/03/1446 AH.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    //MARK:- Register
    
    func registerUserWithNewOrganisation(email: String, password: String, name: String, phoneNumber: String, gender: Gender, organisationName: String, organisationDescription: String, completion: @escaping (_ error: Error?) ->Void) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResults, error) in
            completion(error)
            
            if let user = authResults?.user {
                
                let organisationDoc = FirestoreReference(.organisations).document()
                let organisationID = organisationDoc.documentID
                
                let organisation = Organization(id: organisationID, name: organisationName, description: organisationDescription, rate: 0, numberOfReviewers: 0, volunteersNumber: 0, opportunitiesNumber: 0, completedOpportunitesHours: 0)
                
                let official = Official(id: user.uid, name: name, phoneNumber: phoneNumber, email: email, gender: gender,organizationID: organisationID, role: 0)
                
                OfficialDataService.shared.addOrganisationWithOfficial(organisation: organisation, official: official)
                saveUserLocally(official)
                saveOrganizationLocally(organisation)
            } else {
                
            }
            
        }
    }
    
    func registerUserWithJoinToOrganisation(email: String, password: String, name: String, phoneNumber: String, gender: Gender, organisationInvitation: String, completion: @escaping (_ error: Error?) -> Void) {

        // Check if the organization exists
        let organisationRef = FirestoreReference(.organisations).document(organisationInvitation)
        
        organisationRef.getDocument { (document, error) in
            // If there's an error fetching the organization, return it in completion
            if let error = error {
                completion(error)
                return
            }
            
            // If the document does not exist, return an error
            guard document != nil, document!.exists else {
                let orgNotFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Organization not found"])
                completion(orgNotFoundError)
                return
            }
            
            // If the organization exists, proceed with user registration
            Auth.auth().createUser(withEmail: email, password: password) { (authResults, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                // If user registration is successful
                if let user = authResults?.user {
                    // Create an Official instance with the provided data
                    let official = Official(id: user.uid, name: name, phoneNumber: phoneNumber, email: email, gender: gender, organizationID: organisationInvitation, role: 1)
                    
                    // Add the official to the organization in Firestore
                    OfficialDataService.shared.addOfficialToOrganisation(organisationID: organisationInvitation, official: official)
                    
                    // Save the user locally
                    saveUserLocally(official)
                    
                    // Call the completion handler with no error
                    completion(nil)
                }
            }
        }
    }


    
    //MARK:- Login
    func loginUserWith(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResults, error) in
            if let error = error {
                loginComplete(false, error)
                return
            }
            
            // Assuming user UID is used as `officialID`
            let officialID = authResults!.user.uid
            OfficialDataService.shared.getOfficialDataIfExists(withID: officialID) { exists, organisationOfficial in
                if exists, let officialData = organisationOfficial {
                    // Proceed with login and handle the data if the official exists
                    print("Official data: \(officialData)")
                    // You can now store the data locally or use it as needed
                    saveUserLocally(officialData)  // Example function to save data locally
                    loginComplete(true, nil)
                } else {
                    // Log out if the official does not exist
                    try? Auth.auth().signOut()
                    loginComplete(false, nil)
                }
            }
        }
    }
    
    
    //MARK:- Logout
    func logoutCurrentUser(completion: @escaping (_ error: Error?)-> Void) {
        
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.removeObject(forKey: kCURRENTORGANISATION)
            StudentRealmService.shared.deleteAllStudents()
            OpportunityRealmService.shared.deleteAllOpportunities()
            userDefaults.synchronize()
            completion(nil)
        } catch let error as NSError {
            
            completion(error)
        }
    }
    
    
    //MARK:- Reset password
    
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
        
    }
    
    func deleteAccount(completion: @escaping (_ error: Error?) -> ()) {
        
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(error)
            } else {
                // Remove user info from UserDefaults if delete successful
                userDefaults.removeObject(forKey: kCURRENTUSER)
                userDefaults.removeObject(forKey: kCURRENTORGANISATION)
                StudentRealmService.shared.deleteAllStudents()
                OpportunityRealmService.shared.deleteAllOpportunities()
                userDefaults.synchronize()
                completion(nil)
            }
        }
        
    }
    
    func checkCurrentUserStatus() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    
}

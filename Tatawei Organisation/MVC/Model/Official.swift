//
//  OrganisationOfficial.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 23/03/1446 AH.
//

import Foundation
import FirebaseAuth

enum Gender: String, Codable {
    case male = "ذكر"
    case female = "انثى"
}

struct StudentOpportunity: Codable {
    var isAccepted: Bool
}
 
struct Official: Codable {
    
    var id: String
    var name: String
    var phoneNumber: String
    var email: String
    var gender: Gender
    var organizationID: String
    var role: Int
        
    static var currentID: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentOfficial: Official? {
        
        if Auth.auth().currentUser != nil {
            if let data = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(Official.self, from: data)
                    return userObject
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        return nil
    }
}

func saveUserLocally(_ user: Official) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
        print(error.localizedDescription)
    }
}

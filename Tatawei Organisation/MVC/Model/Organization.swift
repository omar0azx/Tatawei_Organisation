//
//  Organization.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 15/04/1446 AH.
//

import Foundation
import FirebaseAuth

struct Organization: Codable {
    
    var id: String
    var name: String
    var description: String
    var rate: Double
    var numberOfReviewers: Int
    var volunteersNumber: Int
    var opportunitiesNumber: Int

    static var currentOrganization: Organization? {
        
        if Auth.auth().currentUser != nil {
            if let data = UserDefaults.standard.data(forKey: kCURRENTORGANISATION) {
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(Organization.self, from: data)
                    return userObject
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        return nil
    }
}

func saveOrganizationLocally(_ user: Organization) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTORGANISATION)
    } catch {
        print(error.localizedDescription)
    }
}

//
//  opportunities.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 15/04/1446 AH.
//

import Foundation

enum OpportunityStatus: String, Codable {
    case open = "open"
    case inProgress = "in progress"
    case finished = "finished"
}

struct Opportunity: Codable {
    
    var id: String
    var name: String
    var description: String
    var date: String
    var time: String
    var hour: Int
    var city: Cities
    var status: OpportunityStatus
    var category: InterestCategories
    var iconNumber: Int
    var location: String
    var latitude: Double
    var longitude: Double
    var studentsNumber: Int
    var organizationID: String
    var organizationName: String
    
    var formattedDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Use your date format here
            return dateFormatter.date(from: date)
        }
    
    static var allOpportunities: [Opportunity]? {
            if let data = UserDefaults.standard.data(forKey: kCURRENTOPPORTUNITIES) {
                let decoder = JSONDecoder()
                do {
                    let opportunitiesObject = try decoder.decode([Opportunity].self, from: data)
                    return opportunitiesObject
                } catch {
                    print(error.localizedDescription)
                }
            
        }
        return nil
    }
}

func addOpportunityLocally(_ newOpportunity: Opportunity) {
    saveOpportunitiesLocally([newOpportunity])
}


func saveOpportunitiesLocally(_ newOpportunities: [Opportunity]) {

    var currentOpportunities = Opportunity.allOpportunities ?? []
    currentOpportunities.append(contentsOf: newOpportunities)
    
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(currentOpportunities)
        UserDefaults.standard.set(data, forKey: kCURRENTOPPORTUNITIES)
    } catch {
        print("Error saving opportunities: \(error.localizedDescription)")
    }
}

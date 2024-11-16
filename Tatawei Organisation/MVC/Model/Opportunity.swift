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
}

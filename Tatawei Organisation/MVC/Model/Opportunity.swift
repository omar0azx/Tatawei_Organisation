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
    var isStudentsAcceptanceFinished: Bool?
    
    var formattedDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Use your date format here
            return dateFormatter.date(from: date)
        }
}

extension Opportunity {
    func toRealmObject() -> OpportunityObject {
        let object = OpportunityObject()
        object.id = id
        object.name = name
        object.opportunityDescription = description
        object.date = date
        object.time = time
        object.hour = hour
        object.city = city.rawValue // Enum raw value
        object.status = status.rawValue
        object.category = category.rawValue
        object.iconNumber = iconNumber
        object.location = location
        object.latitude = latitude
        object.longitude = longitude
        object.studentsNumber = studentsNumber
        object.organizationID = organizationID
        object.organizationName = organizationName
        object.isStudentsAcceptanceFinished = isStudentsAcceptanceFinished
        return object
    }
}

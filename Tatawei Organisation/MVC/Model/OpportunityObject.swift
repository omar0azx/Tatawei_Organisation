//
//  OpportunityObject.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 17/05/1446 AH.
//

import RealmSwift

class OpportunityObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var opportunityDescription: String
    @Persisted var date: String
    @Persisted var time: String
    @Persisted var hour: Int
    @Persisted var city: String // Save enum raw value as String
    @Persisted var status: String
    @Persisted var category: String
    @Persisted var iconNumber: Int
    @Persisted var location: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var studentsNumber: Int
    @Persisted var acceptedStudents: Int
    @Persisted var organizationID: String
    @Persisted var organizationName: String
    @Persisted var isStudentsAcceptanceFinished: Bool?
}

extension OpportunityObject {
    func toStruct() -> Opportunity? {
        guard let city = Cities(rawValue: city),
              let status = OpportunityStatus(rawValue: status),
              let category = InterestCategories(rawValue: category) else {
            return nil // Handle invalid enum raw values
        }

        return Opportunity(
            id: id,
            name: name,
            description: opportunityDescription,
            date: date,
            time: time,
            hour: hour,
            city: city,
            status: status,
            category: category,
            iconNumber: iconNumber,
            location: location,
            latitude: latitude,
            longitude: longitude,
            studentsNumber: studentsNumber,
            acceptedStudents: acceptedStudents,
            organizationID: organizationID,
            organizationName: organizationName,
            isStudentsAcceptanceFinished: isStudentsAcceptanceFinished
        )
    }
}

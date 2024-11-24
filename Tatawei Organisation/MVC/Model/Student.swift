//
//  Student.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 17/05/1446 AH.
//

import Foundation
import RealmSwift

struct StudentOpportunity: Codable {
    var isAccepted: Bool
    var isAttended: Bool
}

struct Student: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var level: String?
    var opportinitiesNumber: Int?
    var hoursCompleted: Int?
    var gender: Gender
    var isAttended: Bool?

    // Convert Student struct to Realm object (StudentObject)
    func toRealmObject() -> StudentObject {
        let object = StudentObject()
        object.id = id
        object.name = name
        object.gender = gender.rawValue
        object.isAttended = isAttended ?? false // Default to false if nil
        return object
    }
}

class StudentObject: Object {
    @Persisted(primaryKey: true) var id: String  // Ensure uniqueness of Student by id
    @Persisted var name: String
    @Persisted var gender: String // Store Gender as rawValue
    @Persisted var isAttended: Bool  // Default is false
    
    // Convert Realm object back to struct
    func toStruct() -> Student {
        return Student(
            id: id,
            name: name,
            gender: Gender(rawValue: gender) ?? .male, // Default to .male if invalid value
            isAttended: isAttended
        )
    }
}

class OpportunityStudentsObject: Object {
    @Persisted(primaryKey: true) var opportunityID: String
    @Persisted var students: List<StudentObject> // List of students for this opportunity
}

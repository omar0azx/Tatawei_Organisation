//
//  Badges.swift
//  Tatawei Student
//
//  Created by Wesam Kadah on 05/11/2024.
//

import Foundation
import UIKit

enum HoursBadges: String, Codable {
    case hero = "البطل"
    case legend = "الأسطورة"
    case terrible = "الرهيب"
    case experienced = "المحنك"
    case opportunityKiller = "مختم التطوع"
}

enum SkillsBadges: String, Codable {
    case communication = "المتواصل"
    case teamwork = "المتعاون"
    case criticalThinking = "المفكير النقدي"
    case leadership = "القيادي"
    case adaptability = "المتكيف"
    case creativity = "المبدع"
    case resilience = "الصامد"
    case problemSolving = "حلال المشاكل"
}

struct Badge {
    let name: String
    let image: UIImage
}


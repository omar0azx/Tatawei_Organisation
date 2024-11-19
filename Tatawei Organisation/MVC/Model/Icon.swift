//
//  Icon.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 19/04/1446 AH.
//
import UIKit

struct OpportunitiesIcon {
    var categories: InterestCategories
    var image: [UIImage]
}



struct Icon {
    
    var index: Int
    var category: InterestCategories
    
    static var iconsArray: [OpportunitiesIcon] = [
        OpportunitiesIcon(categories: .Arts, image: [#imageLiteral(resourceName: "art-1"), #imageLiteral(resourceName: "art-2"), #imageLiteral(resourceName: "art-3"), #imageLiteral(resourceName: "art-4"), #imageLiteral(resourceName: "art-5"), #imageLiteral(resourceName: "art-6"), #imageLiteral(resourceName: "art-7"), #imageLiteral(resourceName: "art-8")]),
        OpportunitiesIcon(categories: .Cultural, image: [#imageLiteral(resourceName: "social-1"), #imageLiteral(resourceName: "social-2"), #imageLiteral(resourceName: "social-3"), #imageLiteral(resourceName: "social-4"), #imageLiteral(resourceName: "social-5"), #imageLiteral(resourceName: "social-6"), #imageLiteral(resourceName: "social-7"), #imageLiteral(resourceName: "social-8")]),
        OpportunitiesIcon(categories: .Environmental, image: [#imageLiteral(resourceName: "environment-1"), #imageLiteral(resourceName: "environment-2"), #imageLiteral(resourceName: "environment-3"), #imageLiteral(resourceName: "environment-4"), #imageLiteral(resourceName: "environment-5"), #imageLiteral(resourceName: "environment-6"), #imageLiteral(resourceName: "environment-7"), #imageLiteral(resourceName: "environment-8")]),
        OpportunitiesIcon(categories: .Financial, image: [#imageLiteral(resourceName: "finance-1"), #imageLiteral(resourceName: "finance-2"), #imageLiteral(resourceName: "finance-3"), #imageLiteral(resourceName: "finance-4"), #imageLiteral(resourceName: "finance-5"), #imageLiteral(resourceName: "finance-6"), #imageLiteral(resourceName: "finance-7"), #imageLiteral(resourceName: "finance-8")]),
        OpportunitiesIcon(categories: .Healthy, image: [#imageLiteral(resourceName: "health-1"), #imageLiteral(resourceName: "health-2"), #imageLiteral(resourceName: "health-3"), #imageLiteral(resourceName: "health-4"), #imageLiteral(resourceName: "health-5"), #imageLiteral(resourceName: "health-6"), #imageLiteral(resourceName: "health-7"), #imageLiteral(resourceName: "health-8")]),
        OpportunitiesIcon(categories: .Social, image: [#imageLiteral(resourceName: "social-1"), #imageLiteral(resourceName: "social-2"), #imageLiteral(resourceName: "social-3"), #imageLiteral(resourceName: "social-4"), #imageLiteral(resourceName: "social-5"), #imageLiteral(resourceName: "social-6"), #imageLiteral(resourceName: "social-7"), #imageLiteral(resourceName: "social-8")]),
        OpportunitiesIcon(categories: .Sports, image: [#imageLiteral(resourceName: "sport-1"), #imageLiteral(resourceName: "sport-2"), #imageLiteral(resourceName: "sport-3"), #imageLiteral(resourceName: "sport-4"), #imageLiteral(resourceName: "sport-5"), #imageLiteral(resourceName: "sport-6"), #imageLiteral(resourceName: "sport-7"), #imageLiteral(resourceName: "sport-8")]),
        OpportunitiesIcon(categories: .Technical, image: [#imageLiteral(resourceName: "technical-1"), #imageLiteral(resourceName: "technical-2"), #imageLiteral(resourceName: "technical-3"), #imageLiteral(resourceName: "technical-4"), #imageLiteral(resourceName: "technical-5"), #imageLiteral(resourceName: "technical-6"), #imageLiteral(resourceName: "technical-7"), #imageLiteral(resourceName: "technical-8")]),
        OpportunitiesIcon(categories: .Tourism, image: [#imageLiteral(resourceName: "tourism-1"), #imageLiteral(resourceName: "tourism-2"), #imageLiteral(resourceName: "tourism-3"), #imageLiteral(resourceName: "tourism-4"), #imageLiteral(resourceName: "tourism-5"), #imageLiteral(resourceName: "tourism-6"), #imageLiteral(resourceName: "tourism-7"), #imageLiteral(resourceName: "tourism-8")]),
        OpportunitiesIcon(categories: .religious, image: [#imageLiteral(resourceName: "religious-8"), #imageLiteral(resourceName: "religious-6"), #imageLiteral(resourceName: "religious-5"), #imageLiteral(resourceName: "religious-1"), #imageLiteral(resourceName: "religious-2"), #imageLiteral(resourceName: "religious-3"), #imageLiteral(resourceName: "religious-4"), #imageLiteral(resourceName: "religious-7")])
    ]
    
    var opportunityIcon: (UIImage, UIColor) {
        let colorsArray = [#colorLiteral(red: 0.968627451, green: 0.7294117647, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.8705882353, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.8745098039, green: 0.968627451, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.7058823529, green: 0.968627451, blue: 0.6823529412, alpha: 1), #colorLiteral(red: 0.6823529412, green: 0.968627451, blue: 0.8431372549, alpha: 1), #colorLiteral(red: 0.6823529412, green: 0.9450980392, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.6823529412, green: 0.7764705882, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.6823529412, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.6823529412, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.6823529412, blue: 0.7843137255, alpha: 1)]
        if let opportunityIcon = Icon.iconsArray.first(where: { $0.categories == category }) {
            return (opportunityIcon.image[index % opportunityIcon.image.count], colorsArray[index % colorsArray.count])
        }
        return (#imageLiteral(resourceName: "tatawei-intro"), .gray)
    }
}













//
//  OpportunityAttendanceCell.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

class OpportunityAttendanceCell: UICollectionViewCell {
    
    @IBOutlet weak var opportunityImage: UIImageView!
    @IBOutlet weak var opportunityName: UILabel!
    @IBOutlet weak var opportunityTime: UILabel!
    @IBOutlet weak var opportunityDate: UILabel!
    
    
    func config(image: UIImage, name: String, time: String, date: String){
        opportunityImage.image = image
        opportunityName.text = name
        opportunityTime.text = time
        opportunityDate.text = date
    }
}

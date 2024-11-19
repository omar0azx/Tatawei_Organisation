//
//  OpportunityCell.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 16/05/1446 AH.
//

import UIKit

class OpportunityCell: UITableViewCell {
    
    @IBOutlet weak var opportunityView: UIView!
    @IBOutlet weak var opportunityImage: UIImageView!
    @IBOutlet weak var opportunityName: UILabel!
    @IBOutlet weak var opportunityTime: UILabel!
    @IBOutlet weak var opportunityDate: UILabel!
    
    @IBOutlet weak var completedImage: UIImageView!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(backGroundView: UIColor, image: UIImage, name: String, time: String, date: String, isFinished: Bool?) {
        self.opportunityView.backgroundColor = backGroundView
        opportunityImage.image = image
        opportunityName.text = name
        opportunityTime.text = time
        opportunityDate.text = date
        completedImage.image = isFinished ?? false ? #imageLiteral(resourceName: "complete.png") : #imageLiteral(resourceName: "timer.png")
        completedLabel.text = isFinished ?? false ? " مكتمل, جاري التنفيذ" : "بإنتظار قبول الطلاب"
        completedLabel.textColor = isFinished ?? false ? #colorLiteral(red: 0.03529411765, green: 0.6980392157, blue: 0.5215686275, alpha: 1) : #colorLiteral(red: 0.8705882353, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
    }

}



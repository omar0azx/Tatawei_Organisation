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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(backGroundView: UIColor, image: UIImage, name: String, time: String, date: String){
        self.opportunityView.backgroundColor = backGroundView
        opportunityImage.image = image
        opportunityName.text = name
        opportunityName.text = time
        opportunityDate.text = date
    }

}

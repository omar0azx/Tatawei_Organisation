//
//  HomeCell.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 15/05/1446 AH.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var organisationRate: UILabel!
    @IBOutlet weak var numberOfOpportunities: UILabel!
    @IBOutlet weak var numberOfStudents: UILabel!
    @IBOutlet weak var opportunitiesHours: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(organisationRate: String, numberOfOpportunities: String, numberOfStudents: String, opportunitiesHours: String) {
        self.organisationRate.text = organisationRate
        self.numberOfOpportunities.text = numberOfOpportunities
        self.numberOfStudents.text = numberOfStudents
        self.opportunitiesHours.text = opportunitiesHours
        
    }

}

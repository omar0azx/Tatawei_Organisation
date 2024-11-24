//
//  HistoryOpportunitiesCell.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 21/11/2024.
//

import UIKit

class HistoryOpportunitiesCell: UITableViewCell {

    @IBOutlet weak var firstDashedView: DashedView!
    @IBOutlet weak var seconedDashedView: DashedView!
    @IBOutlet weak var opportunityIcon: UIImageView!
    @IBOutlet weak var opportunityDate: UILabel!
    @IBOutlet weak var opportunityTime: UILabel!
    @IBOutlet weak var opportunityName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configOpportunity(opportunityName: String, opportunityTime: String, opportunityDate: String, opportunityIcon: UIImage, isFirstCell: Bool, isLastCell: Bool) {
        
        self.opportunityName.text = opportunityName
        self.opportunityTime.text = opportunityTime
        self.opportunityDate.text = opportunityDate
        self.opportunityIcon.image = opportunityIcon
        
        // Hide first dash if it's the first cell
        firstDashedView.isHidden = isFirstCell
        
        // Hide second dash if it's the last cell
        seconedDashedView.isHidden = isLastCell

        
    }


}

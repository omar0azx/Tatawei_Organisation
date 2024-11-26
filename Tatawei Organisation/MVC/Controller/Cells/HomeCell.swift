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
    
    @IBOutlet weak var rateView: UIView!
    
    @IBOutlet var ratingBarHight: [NSLayoutConstraint]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(organisationRate: Double, numberOfOpportunities: Int, numberOfStudents: Int, opportunitiesHours: Int) {
        self.organisationRate.text = "\(organisationRate)"
        self.numberOfOpportunities.text = "\(numberOfOpportunities)"
        self.numberOfStudents.text = "\(numberOfStudents)"
        self.opportunitiesHours.text = "\(opportunitiesHours)"
        ratingBar(rate: organisationRate)
        
    }
    
    func ratingBar(rate: Double) {
        // Ensure the view has its proper layout before accessing frame height
        rateView.layoutIfNeeded()

        // The total height for a fully filled bar
        let fullBarHeight = rateView.frame.height
        
        // Reset all bars to zero
        for i in 0..<ratingBarHight.count {
            ratingBarHight[i].constant = 0
        }
        
        // Full bars count
        let fullBars = Int(rate)
        
        // Fractional part (e.g., 0.5, 0.8)
        let fractionalPart = rate - Double(fullBars)
        
        // Animate the bar height adjustments
        UIView.animate(withDuration: 0.5, animations: {
            // Fully fill the bars corresponding to the integer part of the rate
            for i in 0..<min(fullBars, self.ratingBarHight.count) {
                self.ratingBarHight[i].constant = fullBarHeight
            }
            
            // Handle the fractional part of the rating
            if fractionalPart > 0 && fullBars < self.ratingBarHight.count {
                self.ratingBarHight[fullBars].constant = fullBarHeight * CGFloat(fractionalPart)
            }
            
            // Ensure all remaining bars are empty, but only loop if fullBars + 1 is valid
            if fullBars + 1 < self.ratingBarHight.count {
                for i in (fullBars + 1)..<self.ratingBarHight.count {
                    self.ratingBarHight[i].constant = 0
                }
            }
            
            // Apply the layout changes
            self.rateView.layoutIfNeeded()
        })
    }


}

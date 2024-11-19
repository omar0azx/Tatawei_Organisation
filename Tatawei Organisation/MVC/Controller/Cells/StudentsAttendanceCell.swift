//
//  StudentsAttendanceCell.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

class StudentsAttendanceCell: UITableViewCell {

    var attendanceButtonTapped: ((Bool) -> Void)?
        private var isButtonSelected: Bool = false {
            didSet {
                // Update the button's appearance whenever the state changes
                if isButtonSelected {
                    attendanceBtn.setImage(UIImage(named: "checkmark"), for: .normal) // Set the image
                } else {
                    attendanceBtn.setImage(nil, for: .normal) // Remove the image
                }
            }
        }
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var attendanceBtn: UIButton!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var numberingLabel: UILabel!
    
    func config(image: UIImage, name: String, numbering: Int, isAttended: Bool) {
        studentName.text = name
        numberingLabel.text = "\(numbering)"
        studentImage.image = image
        isButtonSelected = isAttended
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateButtonAppearance() {
        if isButtonSelected {
            attendanceBtn.setImage(UIImage(named: "checkmark"), for: .normal) // Show checkmark
        } else {
            attendanceBtn.setImage(nil, for: .normal) // Remove checkmark
        }
    }
    
    
    @IBAction func StudentAttendanceAction(_ sender: Any) {
        isButtonSelected.toggle()
        attendanceButtonTapped?(isButtonSelected)

    }
    

}

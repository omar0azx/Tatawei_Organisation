//
//  StudentsAttendanceCell.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

protocol StudentsAttendanceDelegate: AnyObject {
    func chooceNumberTapped(at index:IndexPath)
}

//checkmark
class StudentsAttendanceCell: UITableViewCell {
    
    weak var delegate: StudentsAttendanceDelegate?
    var indexPath:IndexPath!
        
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var attendanceBtn: UIButton!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var numberingLabel: UILabel!
    
    func config(image: UIImage, name: String, numbering: Int, isAttended: Bool) {
        studentName.text = name
        numberingLabel.text = "\(numbering)"
        studentImage.image = image
        attendanceBtn.setImage(isAttended ? UIImage(named: "checkmark") : UIImage(), for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func StudentAttendanceAction(_ sender: Any) {
        delegate?.chooceNumberTapped(at: indexPath)
    }
    
}

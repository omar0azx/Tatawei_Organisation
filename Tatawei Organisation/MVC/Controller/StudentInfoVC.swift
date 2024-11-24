//
//  StudentInfoVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 18/11/2024.
//

import UIKit

class StudentInfoVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    var student: Student?
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentLevel: UILabel!
    @IBOutlet weak var studentPhoneNumber: UILabel!
    
    @IBOutlet weak var completedOpportunities: UILabel!
    @IBOutlet weak var completedHours: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStudentInformation()
    }
    
    //MARK: - @IBAction

    @IBAction func didPressedCallNumber(_ sender: Any) {
        guard let student = student else {return}
        makeCall(to: student.phoneNumber!)
    }
    
    //MARK: - Functions
    
    func getStudentInformation() {
        guard let student = student else {return}
        studentImage.image = student.gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg")
        studentName.text = student.name
        studentLevel.text = student.level
        studentPhoneNumber.text = student.phoneNumber
        
        completedOpportunities.text = String(describing: student.opportinitiesNumber ?? 0)
        completedHours.text = String(describing: student.hoursCompleted ?? 0)
    }
    
    func makeCall(to phoneNumber: String) {
        // Format the phone number by removing spaces and special characters if necessary
        let formattedNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        
        // Create the tel URL
        if let phoneURL = URL(string: "tel://\(formattedNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Phone call not supported on this device or invalid phone number.")
        }
    }
    
}

//
//  IntroAttendanceVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit

class IntroAttendanceVC: UIViewController, Storyboarded {

    //MARK: - Varibales
    var coordinator: MainCoordinator?
    var opportunityNameText: String?
    var opportunityDescriptionText: String?

    //MARK: - @IBOutlet
    @IBOutlet weak var opportunityName: UILabel!
    @IBOutlet weak var opportunityDecription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    //MARK: - @@IBAction

    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func scanBarcode(_ sender: Any) {

        coordinator?.viewQRScannerVC()
    }
    @IBAction func showAllStudentes(_ sender: Any) {

         coordinator?.viewStudentsAttendanceVC()
        
    }
    
    //MARK: - Functions
    func setUpUI() {
        opportunityName.text = opportunityNameText
        opportunityDecription.text = opportunityDescriptionText

    }
    
}

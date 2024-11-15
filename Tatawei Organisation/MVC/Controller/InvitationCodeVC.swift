//
//  InvitationCodeVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 13/05/1446 AH.
//

import UIKit

class InvitationCodeVC: UIViewController, Storyboarded {
    
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    var organisationID: String?
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var organisationCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        organisationCode.text = organisationID
    }
    
    //MARK: - IBAcitions

    
    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func backBTN(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didPressedShare(_ sender: UIButton) {
        guard let organisationID = organisationID else { return }
        let link = URL(string: organisationID)!
        let message = "This Invitation Code To Join: \(link)"
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    
}

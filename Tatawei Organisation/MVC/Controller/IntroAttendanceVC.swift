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
    
    var opportunity: Opportunity?

    //MARK: - @IBOutlet
    @IBOutlet weak var opportunityName: UILabel!
    @IBOutlet weak var opportunityDecription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        getOpportunityStudents()
    }
    
    //MARK: - @@IBAction

    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func scanBarcode(_ sender: Any) {
        guard let opportunity = opportunity else {return}
        coordinator?.viewQRScannerVC(opportunityID: opportunity.id)
    }
    @IBAction func showAllStudentes(_ sender: Any) {
        if let opportunity = opportunity {
            coordinator?.viewStudentsAttendanceVC(opportunityID: opportunity.id)
        }
        
    }
    
    //MARK: - Functions
    
    func setUpUI() {
        if let opportunity = opportunity {
            opportunityName.text = opportunity.name
            opportunityDecription.text = opportunity.description
        }
    }
    
    func getOpportunityStudents() {
        if let opportunityID = opportunity?.id, let organisation = Organization.currentOrganization {
            StudentDataService.shared.getStudentsForAttendance(organisationID: organisation.id, opportunityID: opportunityID) { error in
                if error != nil {
                    print("The students is empty")
                } else {
                    print("Success save students")
                }
            }
        }
    }
    
}

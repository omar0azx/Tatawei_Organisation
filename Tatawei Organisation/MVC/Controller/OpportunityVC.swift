//
//  OpportunityVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 16/05/1446 AH.
//

import UIKit

class OpportunityVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    var opportunity: Opportunity?
    
    
    //MARK: - IBOutleats
    
    @IBOutlet var opportunityView: UIView!
    @IBOutlet weak var opportunityImage: DesignableImage!
    @IBOutlet weak var opportunityName: UILabel!
    @IBOutlet weak var opportunityDescription: UILabel!
    @IBOutlet weak var opportunityTime: UILabel!
    @IBOutlet weak var opportunityLocation: UILabel!
    @IBOutlet weak var opportunityHour: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getOpportunityInformaion()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        getOpportunityInformaion()
    }
    

    //MARK: - IBAcitions
    
    @IBAction func didPressedCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func openLocationInGoogleMaps(_ sender: UIButton) {
        if let opportunity = opportunity {
            if let url = URL(string: "comgooglemaps://?q=\(opportunity.latitude),\(opportunity.longitude)&center=\(opportunity.latitude),\(opportunity.longitude)&zoom=14") {
                // Check if Google Maps is installed
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback to open in browser if Google Maps app is not installed
                    let browserUrl = URL(string: "https://www.google.com/maps/search/?api=1&query=\(opportunity.latitude),\(opportunity.longitude)")!
                    UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    @IBAction func didPressedEdit(_ sender: UIButton) {
        guard let opportunity = opportunity else {return}
        coordinator?.viewEditOpportunityVC(opportunity: opportunity)
    }
    
    @IBAction func didPressedAcceptace(_ sender: UIButton) {
    }
    
    @IBAction func didPressedDeleted(_ sender: UIButton) {
        guard let opportunity = opportunity else {return}
        showCustomAlert(message: "هل أنت متأكد من انك تريد حذف هذه الفرصة؟", onConfirm: {
            let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
            loadView.show(in: self.view)
            OpportunityDataService.shared.deleteOpportunity(opportunityID: opportunity.id) { error in
                if error == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let successView = MessageView(message: "تم حذف الفرصة بنجاح", animationName: "correct", animationTime: 1)
                        successView.show(in: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    let errorView = MessageView(message: "توجد خطأ بعملية الحذف، يرجى المحاولة لاحقا", animationName: "warning", animationTime: 1)
                    errorView.show(in: self.view)
                }
            }
        }, onCancel: {
            print("Action cancelled")
        })
    }
    
    
    
    //MARK: - Functions
    
    func getOpportunityInformaion() {
        if let opportunityID = opportunity?.id {
            if let opportunity = getOpportunityByID(opportunityID) {
                opportunityImage.image = Icon(index: opportunity.iconNumber, category: opportunity.category).opportunityIcon.0
                opportunityView.backgroundColor = Icon(index: opportunity.iconNumber, category: opportunity.category).opportunityIcon.1
                opportunityName.text = opportunity.name
                opportunityDescription.text = opportunity.description
                opportunityTime.text = opportunity.time
                opportunityHour.text = "ساعات \(opportunity.hour)"
                opportunityLocation.text = opportunity.location
            } else {
                
            }
        }
    }
    
    

}

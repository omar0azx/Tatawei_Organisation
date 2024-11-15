//
//  IntroTataweiVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class IntroTataweiVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var tatawei: UIStackView!
    @IBOutlet weak var titel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       animateViews()
        
    }
    
    //MARK: - IBAcitions
    
    
    
    
    //MARK: - Functions
    
    func animateViews() {
        // Fade back in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 1) {
                self.tatawei.isHidden = false
                self.tatawei.alpha = 1
                self.loadViewIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5) {
                    self.titel.isHidden = false
                    self.titel.alpha = 1
                    self.loadViewIfNeeded()
                }
            }
        }
    }
    
}





//
//  StudentSkillsVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 22/11/2024.
//

import UIKit

class StudentSkillsVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    var coordinator: MainCoordinator?
    var selectedButtons: [Int] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var conditionText: UILabel!
    @IBOutlet weak var sendBTN: UIButton!
    @IBOutlet var skillsView: [UIView]!
    @IBOutlet weak var studentStage: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - @IBAction
    @IBAction func didPressedSkills(_ sender: UIButton) {
        toggleButtonSelection(sender)
    }
    
    @IBAction func didPressedSend(_ sender: Any) {
        
    }
    
    //MARK: - Functions
    func toggleButtonSelection(_ sender: UIButton) {
        let tag = sender.tag
        
        // Check if the button is already selected
        if selectedButtons.contains(tag) {
            // If already selected, deselect it
            selectedButtons.removeAll { $0 == tag }
            skillsView[tag].backgroundColor = .systemGray4
            conditionText.textColor = .darkGray
        } else {
            if selectedButtons.count < 3 {
                selectedButtons.append(tag)
                
                switch tag {
                case 0:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 1:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 2:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 3:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 4:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 5:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 6:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                case 7:
                    print("Skill \(tag) selected")
                    skillsView[tag].backgroundColor = .standr
                default:
                    break
                }
            } else {
                vibrateLabel(conditionText)
            }
        }
        updateSendButton()
    }
    
    private func updateSendButton() {
        sendBTN.isHidden = selectedButtons.isEmpty
        
    }
    
    private func vibrateLabel(_ label: UILabel) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        label.textColor = .red
        
        let originalPosition = label.center.x
        let leftPosition = originalPosition - 10
        let rightPosition = originalPosition + 10

        // Animate the label to move left
        UIView.animate(withDuration: 0.1, animations: {
            label.center.x = leftPosition
        }) { _ in
            // Animate back to the right
            UIView.animate(withDuration: 0.1, animations: {
                label.center.x = rightPosition
            }) { _ in
                // Return to the original position
                UIView.animate(withDuration: 0.1, animations: {
                    label.center.x = originalPosition
                })
            }
        }
    }
}

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
    
    var studentID: String?
    
    var selectedButtons: [Int] = []
    var selectedBadges: [SkillsBadges] = [.communication, .resilience, .leadership, .creativity, .teamwork, .adaptability, .criticalThinking, .problemSolving]
    
    var badges: [SkillsBadges] = []

    
    // MARK: - IBOutlets
    @IBOutlet weak var conditionText: UILabel!
    @IBOutlet weak var sendBTN: UIButton!
    @IBOutlet var skillsView: [UIView]!
    @IBOutlet weak var studentStage: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentInformation()
        
    }
    
    // MARK: - @IBAction
    @IBAction func didPressedSkills(_ sender: UIButton) {
        toggleButtonSelection(sender)
    }
    
    @IBAction func didPressedSend(_ sender: Any) {
        for index in selectedButtons {
            if index >= 0 && index < selectedBadges.count {
                badges.append(selectedBadges[index])
            }
        }
        let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
        loadView.show(in: self.view)
        guard let studentID = studentID else {return}
        StudentDataService.shared.incrementBadges(studentID: studentID, selectedBadges: badges) { success, error in
            if error != nil {
                let errorView = MessageView(message: "حدث خطأ بالتقييم يرجى المحاولة لاحقًا", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                print("Cannot Rated Student")
            } else {
                let successView = MessageView(message: "تم تقييم الطالب بنجاح", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                print("Success Rated Student")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func getStudentInformation() {
        
        guard let studentID = studentID else {return}
        StudentDataService.shared.getStudentByID(studentID: studentID) { student, error in
            if error == nil {
                self.studentImage.image = student?.gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg")
                self.studentName.text = student?.name
                self.studentStage.text = student?.level
            } else {
                print("Student Connot Found")
            }
        }

        
    }
    
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
                    skillsView[tag].backgroundColor = .standr
                case 1:
                    skillsView[tag].backgroundColor = .standr
                case 2:
                    skillsView[tag].backgroundColor = .standr
                case 3:
                    skillsView[tag].backgroundColor = .standr
                case 4:
                    skillsView[tag].backgroundColor = .standr
                case 5:
                    skillsView[tag].backgroundColor = .standr
                case 6:
                    skillsView[tag].backgroundColor = .standr
                case 7:
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

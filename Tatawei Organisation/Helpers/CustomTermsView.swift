//
//  TermsVC.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 07/05/1446 AH.
//

import UIKit

class CustomTermsView: UIView {
    
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let termsTextView = UITextView()
    private let declineButton = UIButton(type: .system)
    private let acceptButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupTitleLabel()
        setupTermsTextView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContainerView()
        setupTitleLabel()
        setupTermsTextView()
        setupButtons()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .systemGray5
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "الشروط والأحكام"
        titleLabel.font = UIFont(name: "Cairo-Bold", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    private func setupTermsTextView() {
        // Set up the text with a tappable link
        let termsText = """
            الشروط
            من خلال الوصول إلى هذا الموقع، فإنك توافق على الالتزام بشروط وأحكام الاستخدام هذه...
            اضغط هنا لرؤية الشروط والأحكام

            """

        let attributedString = NSMutableAttributedString(string: termsText)

        // Find the range for "من خلال" and make it clickable
        let linkRange = (termsText as NSString).range(of: "اضغط هنا لرؤية الشروط والأحكام")
        attributedString.addAttribute(.link, value: "https://drive.google.com/file/d/1Bu1MXmMzC-D92-4p6hgOVoNiv_fuMGmD/view?usp=share_link", range: linkRange)
        
        termsTextView.attributedText = attributedString
        termsTextView.isEditable = false
        termsTextView.font = UIFont(name: "Cairo", size: 14)
        termsTextView.textColor = .label
        termsTextView.textAlignment = .right
        termsTextView.backgroundColor = .systemGray4
        termsTextView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(termsTextView)
        
        NSLayoutConstraint.activate([
            termsTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            termsTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            termsTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupButtons() {
        declineButton.setTitle("رفض", for: .normal)
        declineButton.setTitleColor(.systemRed, for: .normal)
        declineButton.layer.borderColor = UIColor.systemRed.cgColor
        declineButton.layer.borderWidth = 1
        declineButton.layer.cornerRadius = 5
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.addTarget(self, action: #selector(declineTapped), for: .touchUpInside)
        containerView.addSubview(declineButton)
        
        acceptButton.setTitle("قبول", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = .standr
        acceptButton.layer.cornerRadius = 5
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        containerView.addSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            declineButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            declineButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            declineButton.widthAnchor.constraint(equalToConstant: 120),
            declineButton.heightAnchor.constraint(equalToConstant: 40),
            
            acceptButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            acceptButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            acceptButton.widthAnchor.constraint(equalToConstant: 120),
            acceptButton.heightAnchor.constraint(equalToConstant: 40),
            
            termsTextView.bottomAnchor.constraint(equalTo: declineButton.topAnchor, constant: -20)
        ])
    }
        
        private func openTermsAndConditions() {
            if let url = URL(string: "https://drive.google.com/file/d/1nRsDhVX1rqk7Em2VW1vIeIC8OZUzeTdR/view?usp=drive_link") {
                UIApplication.shared.open(url)
            }
        }
    
    @objc private func acceptTapped() {
        confirmAction?()
    }
    
    @objc private func declineTapped() {
        cancelAction?()
    }
}


extension UIViewController {
    
    func showCustomTermsView(onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        // Create a blur effect view for the background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 1001 // For later removal
        
        // Add the blur effect view to the main view
        self.view.addSubview(blurEffectView)
        
        // Create and configure the custom terms view
        let termsView = CustomTermsView()
        termsView.translatesAutoresizingMaskIntoConstraints = false
        termsView.tag = 1002 // For later removal
        
        // Set the closures for confirm and cancel actions
        termsView.confirmAction = {
            onConfirm() // Call the onConfirm closure
            termsView.removeFromSuperview() // Remove terms view
            blurEffectView.removeFromSuperview() // Remove blur effect view
        }
        
        termsView.cancelAction = {
            onCancel() // Call the onCancel closure
            termsView.removeFromSuperview() // Remove terms view
            blurEffectView.removeFromSuperview() // Remove blur effect view
        }
        
        self.view.addSubview(termsView)
        
        // Constraints to center the alert and make it square
        NSLayoutConstraint.activate([
            termsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            termsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            termsView.widthAnchor.constraint(equalToConstant: 300),
            termsView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        // Animate the appearance of the alert and blur effect
        termsView.alpha = 0
        blurEffectView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            termsView.alpha = 1
            blurEffectView.alpha = 0.5
        }
        
        // Add tap gesture recognizer to the blur effect view to dismiss the terms view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTapp(_:)))
        blurEffectView.addGestureRecognizer(tapGesture)
    }
    
    // Method to handle the tap outside of the alert
    @objc private func handleOutsideTapp(_ sender: UITapGestureRecognizer) {
        if let blurEffectView = self.view.viewWithTag(1001), let alertView = self.view.viewWithTag(1002) {
            // Remove both the alert and the blur effect view
            UIView.animate(withDuration: 0.3, animations: {
                blurEffectView.alpha = 0
                alertView.alpha = 0
            }) { _ in
                blurEffectView.removeFromSuperview()
                alertView.removeFromSuperview()
            }
        }
    }
}

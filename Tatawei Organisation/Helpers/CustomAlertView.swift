//
//  CustomAlertView.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 01/04/1446 AH.
//

import UIKit

class CustomAlertView: UIView {

    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "هل أنت متأكد من حذف حسابك ؟"
        label.font = UIFont(name: "Cairo", size: 18)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Cairo", size: 15)
        button.setTitle("نعم", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Cairo", size: 15)
        button.setTitle("لا", for: .normal)
        button.backgroundColor = .systemGray4
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    // Initialize the alert view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Configure the alert view
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 20
        self.clipsToBounds = true

        // Add subviews and constraints
        addSubview(messageLabel)
        addSubview(noButton)
        addSubview(yesButton)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Message Label constraints
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Yes Button constraints
            noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            noButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            noButton.heightAnchor.constraint(equalToConstant: 40),
            noButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),

            // No Button constraints
            yesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            yesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            yesButton.heightAnchor.constraint(equalToConstant: 40),
            yesButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
        ])

        // Button actions
        yesButton.addTarget(self, action: #selector(didTapYes), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(didTapNo), for: .touchUpInside)
    }

    // Button actions
    @objc private func didTapYes() {
        confirmAction?()
    }

    @objc private func didTapNo() {
        cancelAction?()
    }
}


extension UIViewController {

    func showCustomAlert(message: String, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        // Create a blur effect view for the background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add the blur effect view to the main view
        self.view.addSubview(blurEffectView)
        
        // Create and configure the custom alert view
        let alertView = CustomAlertView()
        alertView.messageLabel.text = message

        // Set the actions for buttons
        alertView.confirmAction = {
            onConfirm()
            alertView.removeFromSuperview()
            blurEffectView.removeFromSuperview()
        }
        alertView.cancelAction = {
            onCancel()
            alertView.removeFromSuperview()
            blurEffectView.removeFromSuperview()
        }

        alertView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(alertView)

        // Constraints to center the alert and make it square
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        // Animate the appearance of the alert and blur effect
        alertView.alpha = 0
        blurEffectView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            alertView.alpha = 1
            blurEffectView.alpha = 0.5
        }
        
        // Add tap gesture recognizer to the blur effect view to dismiss the alert when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        blurEffectView.addGestureRecognizer(tapGesture)
        
        // Store references to the alert and blur effect views so they can be dismissed
        blurEffectView.tag = 1001  // Tag for finding and removing the blur view later
        alertView.tag = 1002       // Tag for finding and removing the alert view later
    }
    
    // Method to handle the tap outside of the alert
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
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
import UIKit
import Lottie

class MessageView: UIView {
    
    // Lottie animation view
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "warning") // Default animation name
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .playOnce
        return animation
    }()
    
    private var animationTime: Double
    
    // Message label
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Cairo", size: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Blur effect view
        private let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            return blurEffectView
        }()
    
    // Initializer
    init(message: String, animationName: String, animationTime: Double) {
        
        self.animationTime = animationTime
        
        super.init(frame: .zero)
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor.systemGray4
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the animation name
        animationView.animation = LottieAnimation.named(animationName)
        
        // Add the Lottie animation and message label to the view
        addSubview(animationView)
        addSubview(messageLabel)
        addSubview(blurEffectView)
        
        // Set the message
        messageLabel.text = message
        
        // Constraints for animationView
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for messageLabel
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
        
        // Start Lottie animation
        animationView.play()
        
        // Set up the blur effect view
        setupBlurEffect()
        
        // Add tap gesture recognizer to dismiss the alert
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
                blurEffectView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Show the message view with animation
    func show(in view: UIView) {
        view.addSubview(blurEffectView)
        view.addSubview(self)
        
        // Constraints to center the message view in the screen
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: 250),
            self.heightAnchor.constraint(equalToConstant: 200),
            
            // Constraints for blur effect view to fill the screen
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Initial state (hidden)
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Animate showing the view
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }) { _ in
            // Hide the view after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationTime) {
                self.hide()
            }
        }
    }
    
    // Hide the message view with animation
    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
        }
    }
    
    // Set up the blur effect view
    private func setupBlurEffect() {
        blurEffectView.alpha = 0.5 // Adjust the blur effect's alpha as needed
    }
    
    // Method to handle the tap outside of the alert
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        hide() // Simply call hide to remove the message and blur effect
    }
}


//
//  LoginVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class LoginVC: UIViewController, Storyboarded {
    
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Cairo-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
    ]
    
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailTF: DesignableTextField!
    @IBOutlet weak var passwordTF: DesignableTextField!
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    @IBOutlet weak var forgetPassword: UIButton!
    
    @IBOutlet weak var loginBTN: DesignableButton!
    
    @IBOutlet weak var createAccountStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        if forgetPassword.titleLabel?.text == "نسيت كلمة المرور ؟" {
            updateUI(title: "إسترجاع كلمة المرور", passwordHidden: true, forgetPasswordTitle: "لدي حساب بالفعل !", loginButtonTitle: "إرسال", createAccountHidden: true)
        } else {
            updateUI(title: "تسجيل الدخول", passwordHidden: false, forgetPasswordTitle: "نسيت كلمة المرور ؟", loginButtonTitle: "دخول", createAccountHidden: false)
        }
    }
    
    
    @IBAction func loginBTN(_ sender: DesignableButton) {
        if loginBTN.titleLabel?.text == "إرسال" {
            if !emailTF.text!.isValidEmail() {
                let errorView = MessageView(message: "البريد الإلكتروني غير صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return
            }
            AuthService.shared.resetPasswordFor(email: emailTF.text!) { error in
                if error == nil {
                    self.coordinator?.viewforgetPasswordVC()
                    self.updateUI(title: "تسجيل الدخول", passwordHidden: false, forgetPasswordTitle: "نسيت كلمة المرور ؟", loginButtonTitle: "دخول", createAccountHidden: false)
                } else {
                    let errorView = MessageView(message: "لم يتم إرسال رابط لبريدك لتغيير كلمة المرور، تحقق من صحة بريدك", animationName: "warning", animationTime: 1)
                    errorView.show(in: self.view)
                }
            }
        } else {
            if !emailTF.text!.isValidEmail() {
                let errorView = MessageView(message: "البريد الإلكتروني غير صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return
            } else if passwordTF.text!.count < 6 {
                let errorView = MessageView(message: "كلمة المرور غير صحيحة، يجب ان تحتوي على 6 او أكثر", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return
            }
            signIn()
        }
    }
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        coordinator?.viewRegisterVC()
    }

    
    //MARK: - Functions
    
    func updateUI(title: String, passwordHidden: Bool, forgetPasswordTitle: String, loginButtonTitle: String, createAccountHidden: Bool) {
        titleLabel.text = title
        passwordStackView.isHidden = passwordHidden
        forgetPassword.setTitle(forgetPasswordTitle, for: .normal)
        let attributedTitle = NSAttributedString(string: loginButtonTitle, attributes: self.attributes)
        loginBTN.setAttributedTitle(attributedTitle, for: .normal)
        createAccountStackView.isHidden = createAccountHidden
    }
    
    //MARK:- Login User
    
    private func signIn() {
        let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
        loadView.show(in: self.view)
        AuthService.shared.loginUserWith(withEmail: emailTF.text!, andPassword: passwordTF.text!) { status, error in
            if status {
                let successView = MessageView(message: "تم تسجيلك بنجاح، سيتم نقلك للصفحة الرئيسية بعد لحظات", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.coordinator?.viewNavigationVC()
                    self.dismiss(animated: true)
                }
            } else {
                let errorView = MessageView(message: "فشل عملية تسجيل الدخول، تحقق من بريدك وكلمة المرور", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
        }
    }
    

}


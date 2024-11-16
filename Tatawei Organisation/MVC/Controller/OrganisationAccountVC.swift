//
//  OrganisationAccountVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit
//import FirebaseAuth

class OrganisationAccountVC: UIViewController, Storyboarded, UploadLogo {
    
    enum Mode {
        case register
        case editProfile
    }
    
    
    //MARK: - Varibales
    
    var mode: Mode = .register
    
    var coordinator: MainCoordinator?
    
    var stepNumber = 0
    
    var typeNumber = 0
    
    var gender: [String] = ["", Gender.male.rawValue, Gender.female.rawValue]
    
    
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backBTN: DesignableButton!
    
    @IBOutlet weak var widthPar: NSLayoutConstraint!
    
    @IBOutlet weak var nextBTN: DesignableButton!
    
    
    //View One
    @IBOutlet weak var informationUserView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwordStackView: UIStackView!
    
    //View Two
    @IBOutlet weak var DefineTypeView: UIView!
    @IBOutlet var radioViews: [DesignableView]!
    
    //View Three
    @IBOutlet weak var joinToOrganisationView: UIView!
    @IBOutlet weak var invitationCodeTF: UITextField!
    
    //View four
    @IBOutlet weak var organisationView: UIView!
    @IBOutlet weak var organisationNameTF: UITextField!
    @IBOutlet weak var organisationAbout: UITextView!
    @IBOutlet weak var organisationImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definePageType()
        genderTF.convertToPicker(options: gender)
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func definePageType() {
        if mode == .editProfile {
            if let official = Official.currentOfficial, let organisation = Organization.currentOrganization {
                titleLabel.text = "تعديل الحساب"
                nameTF.text = official.name
                genderTF.text = official.gender.rawValue
                phoneNumberTF.text = official.phoneNumber
                emailTF.text = "لا يمكنك تغيير البريد الالكتروني، راجع مشرفك"
                emailTF.isEnabled = false
                passwordStackView.isHidden = true
                organisationNameTF.text = organisation.name
                organisationAbout.text = organisation.description
                StorageService.shared.downloadImage(from: "organisations_icons/\(official.organizationID).jpg") { imag, error in
                    guard let image = imag else {return}
                    self.organisationImage.image = image
                }
            }
            
        } else {
            titleLabel.text = "إنشاء الحساب"
        }
            
    }
    
    @IBAction func didPressedCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func backBTN(_ sender: UIButton) {
        if stepNumber > 0 {
            if mode == .register {
                if stepNumber == 3 {
                    stepNumber = 1
                } else {
                    stepNumber -= 1
                }
            } else {
                guard let official = Official.currentOfficial else {return}
                if official.role == 0 && stepNumber == 3 {
                    stepNumber = 0
                }
            }
        }
        updateStepsUI()
    }
    
    @IBAction func chooseType(_ sender: UIButton) {
        if sender.tag == 0 {
            radioViews[0].backgroundColor = .standr
            radioViews[1].backgroundColor = .systemGray5
            typeNumber = 0
        } else {
            radioViews[0].backgroundColor = .systemGray5
            radioViews[1].backgroundColor = .standr
            typeNumber = 1
        }
    }
    
    @IBAction func didPressedNext(_ sender: UIButton) {
        validInformation()
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        coordinator?.viewUploadLogoVC(data: self)
    }
    
    func didGetLogo(image: UIImage) {
        print(image)
        organisationImage.image = image
    }
    
    
    //MARK: - Functions
    
    func updateStepsUI() {
        func configureContainers(widthConstant: CGFloat, alphaOne: CGFloat, alphaTwo: CGFloat, alphaThree: CGFloat, alphaFour: CGFloat) {
            UIView.animate(withDuration: 0.2) {
                self.widthPar.constant = widthConstant
                
                self.informationUserView.alpha = alphaOne
                self.informationUserView.isHidden = alphaOne == 0
                
                self.DefineTypeView.alpha = alphaTwo
                self.DefineTypeView.isHidden = alphaTwo == 0
                
                self.joinToOrganisationView.alpha = alphaThree
                self.joinToOrganisationView.isHidden = alphaThree == 0
                
                self.organisationView.alpha = alphaFour
                self.organisationView.isHidden = alphaFour == 0
                self.loadViewIfNeeded()
                
            }
        }
        
        switch stepNumber {
        case 0:
            configureContainers(widthConstant: 300, alphaOne: 1, alphaTwo: 0, alphaThree: 0, alphaFour: 0)
            backBTN.isHidden = true // Hide back button on first step
            backBTN.alpha = 0
            nextBTN.isEnabled = true
            
        case 1:
            configureContainers(widthConstant: 150, alphaOne: 0, alphaTwo: 1, alphaThree: 0, alphaFour: 0)
            nextBTN.setTitle("التالي", for: .normal)
            backBTN.isHidden = false // Show back button
            backBTN.alpha = 1
            nextBTN.isEnabled = true
            
        case 2:
            configureContainers(widthConstant: 0, alphaOne: 0, alphaTwo: 0, alphaThree: 1, alphaFour: 0)
            if mode == .register {
                nextBTN.setTitle("إنشاء", for: .normal)
            } else {
                nextBTN.setTitle("تعديل", for: .normal)
            }
            backBTN.isHidden = false
            backBTN.alpha = 1
            nextBTN.isEnabled = true
            
        case 3:
            configureContainers(widthConstant: 0, alphaOne: 0, alphaTwo: 0, alphaThree: 0, alphaFour: 1)
            if mode == .register {
                nextBTN.setTitle("إنشاء", for: .normal)
            } else {
                nextBTN.setTitle("تعديل", for: .normal)
            }
            backBTN.isHidden = false 
            backBTN.alpha = 1
            nextBTN.isEnabled = true
            
        default:
            if mode == .editProfile {
                let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                loadView.show(in: self.view)
            }
            backBTN.alpha = 1
            nextBTN.isEnabled = false
        }
    }
    
    func validInformation() {
        // Only proceed with the validations if the current step is valid
        switch stepNumber {
        case 0:
            // Check all conditions before incrementing stepNumber
            var allValid = true // Track if all validations are successful
            
            if !nameTF.text!.isValidFullName() {
                let errorView = MessageView(message: "الاسم غير صحيح او غير مكتمل، يرجى إدخال الإسم الثلاثي", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if genderTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى اختيار الجنس", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if !phoneNumberTF.text!.isValidPhoneNumber() {
                let errorView = MessageView(message: "رقم الهاتف غير مكتمل او غير صحيح، يجب أن يبدأ ب 05", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if !emailTF.text!.isValidEmail() && mode == .register {
                let errorView = MessageView(message: "البريد الإلكتروني غير صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if passwordTF.text!.count < 6 && mode == .register {
                let errorView = MessageView(message: "كلمة المرور غير صحيحة، يجب ان تحتوي على 6 عناصر او أكثر", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            }
            
            // Only increment stepNumber if all validations are successful
            if allValid {
                print("allValid")
                if mode == .register {
                    print("register")
                    stepNumber += 1
                }
                if let officialRole = Official.currentOfficial?.role {
                    if mode == .editProfile && officialRole == 0 {
                        print("editProfile")
                        stepNumber = 3
                    } else if officialRole == 1 {
                        let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                        loadView.show(in: self.view)
                        updateUser()
                    }
                }
                updateStepsUI()
            }
            
        case 1:
            if typeNumber == 0 {
                stepNumber = 3
            } else {
                stepNumber = 2
            }
            updateStepsUI()
            
        case 2:
            if invitationCodeTF.text == "" || invitationCodeTF.text!.count < 5 {
                let errorView = MessageView(message: "يرجى إدخال الرمز بشكل صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            if mode == .register {
                let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                loadView.show(in: self.view)
                registerUserJoinToOrganisation()
            }
            updateStepsUI()
            
        case 3:
            // Example validation for step 1 (add your conditions)
            if organisationNameTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى إدخال اسم المنظمة", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if organisationAbout.text!.isEmpty {
                let errorView = MessageView(message: "يرجى إدخال شرح عن المنظمة", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if organisationImage.image == nil {
                let errorView = MessageView(message: "يرجى إدخال صورة المنظمة", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
//            
            // Proceed to next step only if all fields are filled in step 1
            
            if mode == .register {
                showCustomTermsView(onConfirm: {
                    print("Account Deleted")
                    let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                    loadView.show(in: self.view)
                    self.registerUserWithNewOrganisation()
                }, onCancel: {
                    self.nextBTN.isEnabled = true
                    print("Cancelled")
                })
            } else {
                let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                loadView.show(in: self.view)
                updateUser()
            }
            updateStepsUI()
            
        default:
            stepNumber = 3
            print("validInformation")
        }
    }
    
    private func registerUserWithNewOrganisation() {
        AuthService.shared.registerUserWithNewOrganisation(email: emailTF.text!, password: passwordTF.text!, name: nameTF.text!, phoneNumber: phoneNumberTF.text!, gender: Gender(rawValue: genderTF.text!)!, organisationName: organisationNameTF.text!, organisationDescription: organisationAbout.text!) { error in
            if error == nil {
                let successView = MessageView(message: "تم تسجيلك بنجاح، سيتم نقلك للصفحة الرئيسية بعد لحظات", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                self.uploadAvatarImage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.coordinator?.viewNavigationVC()
                    self.dismiss(animated: true)
                }
            } else {
                let errorView = MessageView(message: "عملية التسجيل غير ناجحة، يرجى إعادة المحاولة مرة اخرى", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
        }
        
    }
    
    private func registerUserJoinToOrganisation() {
        AuthService.shared.registerUserWithJoinToOrganisation(email: emailTF.text!, password: passwordTF.text!, name: nameTF.text!, phoneNumber: phoneNumberTF.text!, gender: Gender(rawValue: genderTF.text!)!, organisationInvitation: invitationCodeTF.text!) { error in
            if error == nil {
                let successView = MessageView(message: "تم تسجيلك بنجاح، سيتم نقلك للصفحة الرئيسية بعد لحظات", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                self.uploadAvatarImage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.coordinator?.viewNavigationVC()
                    self.dismiss(animated: true)
                }
            } else {
                let errorView = MessageView(message: "عملية التسجيل غير ناجحة، يرجى إعادة المحاولة مرة اخرى", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
        }
        
    }
        
    private func updateUser() {
        // Ensure that we have the currently saved official
        guard let currentOfficial = Official.currentOfficial,
              let currentOrganisation = Organization.currentOrganization else {
            print("Current official or organization not found.")
            return
        }
        
        // Gather current form input values
        let updatedName = nameTF.text ?? ""
        let updatedGender = genderTF.text ?? ""
        let updatedPhoneNumber = phoneNumberTF.text ?? ""
        
        let updatedOragnisationName = organisationNameTF.text ?? ""
        let updatedOragnisationAbout = organisationAbout.text ?? ""
        
        // Create a new official object with the updated values
        var updatedOfficial = currentOfficial
        var updatedOrganisation = currentOrganisation
        
        var hasUserChanges = false
        var hasOrganisationChanges = false
        
        // Check if any of the profile details have changed
        if updatedName != currentOfficial.name {
            updatedOfficial.name = updatedName
            hasUserChanges = true
        }
        
        if updatedGender != currentOfficial.gender.rawValue {
            updatedOfficial.gender = Gender(rawValue: updatedGender)!
            hasUserChanges = true
        }
        
        if updatedPhoneNumber != currentOfficial.phoneNumber {
            updatedOfficial.phoneNumber = updatedPhoneNumber
            hasUserChanges = true
        }
        
        if updatedOragnisationName != currentOrganisation.name {
                updatedOrganisation.name = updatedOragnisationName
                hasOrganisationChanges = true
            }
            
        if updatedOragnisationAbout != currentOrganisation.description {
                updatedOrganisation.description = updatedOragnisationAbout
                hasOrganisationChanges = true
        }
        
        
        // If there is no change, show a message and return
        if !hasUserChanges && currentOfficial.role != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let errorView = MessageView(message: "لا توجد تغييرات لتحديثها", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
            print("No changes detected.")
            return
        }
        
        if !hasUserChanges && !hasOrganisationChanges && currentOfficial.role == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let errorView = MessageView(message: "لا توجد تغييرات لتحديثها", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
            print("No changes detected.")
            return
        }
        
        
        if hasUserChanges {
            OfficialDataService.shared.updatedOfficialAccount(updatedData: updatedOfficial, completion: { error in
                //Show Success/Failure Message After All Updates
                let successView = MessageView(message: "تم تحديث بياناتك بنجاح", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.dismiss(animated: true)
                }
            })
        }
        
        if hasOrganisationChanges {
            OfficialDataService.shared.updatedOrganisationAccount(updatedData: updatedOrganisation, organizationID: currentOfficial.organizationID, completion: { error in
                //Show Success/Failure Message After All Updates
                let successView = MessageView(message: "تم تحديث بياناتك بنجاح", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.dismiss(animated: true)
                }
            })
        }
    }
    

    
    private func uploadAvatarImage() {
        DispatchQueue.main.async {
            if let organisationOfficial = Official.currentOfficial, let image = self.organisationImage.image {
                let fileDirectory = "organisations_icons/" + "\(organisationOfficial.organizationID)" + ".jpg"
                StorageService.shared.uploadImage(image, directory: fileDirectory) { avatarLink in
                    StorageService.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: organisationOfficial.organizationID)
                }
            }
        }
    }
    

}

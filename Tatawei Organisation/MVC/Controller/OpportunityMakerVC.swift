//
//  OpportunityMakerVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 14/05/1446 AH.
//

import UIKit

class OpportunityMakerVC: UIViewController, Storyboarded, DataSelectionDelegate {
    
    enum Mode {
            case addNewOpportunity
            case editOpportunity
        }
    
    
    //MARK: - Varibales
    
    var mode: Mode = .addNewOpportunity
    
    var coordinator: MainCoordinator?
    
    var selectedCategory: InterestCategories?
    
    var filteredImages: [UIImage] = []
    
    var stepNumber = 0
    
    var selectedIndex: IndexPath?
    
    var cities: [String] = ["", Cities.Jeddah.rawValue, Cities.Riyadh.rawValue, Cities.Macca.rawValue, Cities.Madenah.rawValue, Cities.Taif.rawValue, Cities.Dammam.rawValue, Cities.Abha.rawValue]
    var interestsType: [String] = ["", InterestCategories.Cultural.rawValue, InterestCategories.Financial.rawValue, InterestCategories.Social.rawValue, InterestCategories.Sports.rawValue, InterestCategories.Technical.rawValue, InterestCategories.Tourism.rawValue, InterestCategories.Healthy.rawValue, InterestCategories.Arts.rawValue, InterestCategories.Environmental.rawValue, InterestCategories.religious.rawValue]
    
    var latitude: Double?
    var longitude: Double?
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var backBTN: DesignableButton!
    
    @IBOutlet weak var widthPar: NSLayoutConstraint!
    
    @IBOutlet weak var nextBTN: DesignableButton!
    
    //stepOne
    
    @IBOutlet weak var stepOneView: UIView!
    @IBOutlet weak var opportunityNameTF: UITextField!
    @IBOutlet weak var opportunityDescriptionTF: UITextView!
    @IBOutlet weak var opportunityDateTF: UITextField!
    @IBOutlet weak var opportunityTimeTF: UITextField!
    
    //stepTwo
    
    @IBOutlet weak var stepTwoView: UIView!
    @IBOutlet weak var studentsNumberTF: UITextField!
    @IBOutlet weak var opportunityHoursTF: UITextField!
    @IBOutlet weak var opportunityCategoriesTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //step three
    
    @IBOutlet weak var stepThreeView: UIView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var locationInformation: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        opportunityDateTF.convertToDate()
        opportunityTimeTF.convertToTime()
        studentsNumberTF.convertToPicker(options: ["", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"])
        opportunityHoursTF.convertToPicker(options: ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
        opportunityCategoriesTF.convertToPicker(options: interestsType)
        cityTF.convertToPicker(options: cities)
        self.hideKeyboardWhenTappedAround()

    }
    

    //MARK: - IBAcitions
    
    @IBAction func didPressedCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func backBTN(_ sender: UIButton) {
        if stepNumber > 0 {
            stepNumber -= 1
        }
        updateStepsUI()
    }
    
    @IBAction func nextBTN(_ sender: UIButton) {
        validInformation()
    }
    
    @IBAction func openGoogleMap(_ sender: UIButton) {
        coordinator?.viewOMapVC(data: self)
    }
    
    func didSelectData(address: String, latitude: Double, longitude: Double) {
        locationInformation.text = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
    //MARK: - Functions
    
    func updateStepsUI() {
        func configureContainers(widthConstant: CGFloat, alphaOne: CGFloat, alphaTwo: CGFloat, alphaThree: CGFloat) {
            UIView.animate(withDuration: 0.2) {
                self.widthPar.constant = widthConstant
                
                self.stepOneView.alpha = alphaOne
                self.stepOneView.isHidden = alphaOne == 0
                
                self.stepTwoView.alpha = alphaTwo
                self.stepTwoView.isHidden = alphaTwo == 0
                
                self.stepThreeView.alpha = alphaThree
                self.stepThreeView.isHidden = alphaThree == 0

                self.loadViewIfNeeded()
                
            }
        }
        
        switch stepNumber {
        case 0:
            configureContainers(widthConstant: 300, alphaOne: 1, alphaTwo: 0, alphaThree: 0)
            backBTN.isHidden = true // Hide back button on first step
            backBTN.alpha = 0
            nextBTN.isEnabled = true
            
        case 1:
            configureContainers(widthConstant: 150, alphaOne: 0, alphaTwo: 1, alphaThree: 0)
            nextBTN.setTitle("التالي", for: .normal)
            backBTN.isHidden = false // Show back button
            backBTN.alpha = 1
            nextBTN.isEnabled = true
            
        case 2:
            configureContainers(widthConstant: 0, alphaOne: 0, alphaTwo: 0, alphaThree: 1)
            if mode == .addNewOpportunity {
                nextBTN.setTitle("إنشاء", for: .normal)
            } else {
                nextBTN.setTitle("تعديل", for: .normal)
            }
            backBTN.alpha = 1
            nextBTN.isEnabled = true
            
        default:
            if mode == .editOpportunity {
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
            
            if opportunityNameTF.text!.count < 15 {
                let errorView = MessageView(message: "اسم الفرصة غير صحيح او غير مكتمل، يرجى إدخال الإسم بطريقة صحيحة", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if opportunityDescriptionTF.text!.count < 15 {
                let errorView = MessageView(message: "يرجى ادخال وصف الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if opportunityDateTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى ادخال تاريخ الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            } else if opportunityTimeTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى ادخال وقت الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                allValid = false
            }
            
            // Only increment stepNumber if all validations are successful
            if allValid {
                stepNumber += 1
                updateStepsUI()
            }
            
        case 1:
            // Example validation for step 1 (add your conditions)
            
            if studentsNumberTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى ادخال عدد طلاب الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if opportunityHoursTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى ادخال عدد ساعات الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if opportunityCategoriesTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى اختيار تصنيف الفرصة التطوعية", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if selectedIndex == nil {
                let errorView = MessageView(message: "عليك إختيار ايقونة للتصنيف", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            // Proceed to next step only if all fields are filled in step 1
            stepNumber += 1
            updateStepsUI()
            
        case 2:
            
            if cityTF.text!.isEmpty {
                let errorView = MessageView(message: "يرجى إدخال المدينة", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if locationInformation.text == "معلومات الموقع" {
                let errorView = MessageView(message: "يرجى تحديد موقعك الحالي", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return // Do not increment
            }
            
            if mode == .addNewOpportunity {
                let loadView = MessageView(message: "يرجى الإنتظار", animationName: "loading", animationTime: 1)
                loadView.show(in: self.view)
                addNewOpportunity()
            } else {
//                    updateUser()
            }
            
            updateStepsUI()
            
        default:
            stepNumber = 3
            print("validInformation")
        }
    }
    
    func filterImages(for category: InterestCategories) {
        if let selectedIcon = Icon.iconsArray.first(where: { $0.categories == category }) {
            filteredImages = selectedIcon.image
        } else {
            filteredImages = [] // No images if category not found
        }
        collectionView.reloadData()
    }
    
    private func addNewOpportunity() {
        guard let organisation = Organization.currentOrganization else {return}
        OpportunityDataService.shared.addNewOpportunity(organisationID: organisation.id, name: opportunityNameTF.text!, description: opportunityDescriptionTF.text!, date: opportunityDateTF.text!, time: opportunityTimeTF.text!, hour: Int(opportunityHoursTF.text!)!, city: Cities(rawValue: cityTF.text!)!, status: .open, category: InterestCategories(rawValue: opportunityCategoriesTF.text!)!, iconNumber: selectedIndex!.row, location: locationInformation.text!, latitude: latitude!, longitude: longitude!, studentsNumber: Int(studentsNumberTF.text!)!, organizationName: organisation.name) { success, error in
            if error == nil {
                let successView = MessageView(message: "تم إضافة الفرصة بنجاح، سيتم نقلك للصفحة الرئيسية بعد لحظات", animationName: "correct", animationTime: 1)
                successView.show(in: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                    self.dismiss(animated: true)
                }
            } else {
                let errorView = MessageView(message: "عملية التسجيل غير ناجحة، يرجى إعادة المحاولة مرة اخرى", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            }
        }
        
    }

}

extension OpportunityMakerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        
        let backgroundView = selectedIndex == indexPath ? UIColor.standr : UIColor.systemGray5
        cell.config(backGroundView: backgroundView, image: filteredImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If a cell is already selected, reset its background
        if let previousIndex = selectedIndex {
            let previousCell = collectionView.cellForItem(at: previousIndex) as? IconCell
            previousCell?.config(backGroundView: .systemGray5, image: filteredImages[previousIndex.row])
        }
        
        // If the same cell is tapped again, deselect it (reset background)
        if selectedIndex == indexPath {
            selectedIndex = nil
        } else {
            // Select the new cell and change its background
            selectedIndex = indexPath
        }
        
        // Reload the collection view to update the backgrounds
        collectionView.reloadData()
    }
    
}

extension OpportunityMakerVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var interestsType: [InterestCategories] = [.Cultural, .Financial, .Social, .Sports, .Technical, .Tourism, .Healthy, .Arts, .Environmental, .religious]

        if let selectedText = opportunityCategoriesTF.text, !selectedText.isEmpty {
            // Ensure the index is within bounds of interestsType
            opportunityCategoriesTF.didSelectOption = { selectedIndex in
                // Check if selectedIndex is valid for interestsType array
                self.selectedIndex = nil
                if selectedIndex > 0 && selectedIndex <= interestsType.count {
                    self.filterImages(for: interestsType[selectedIndex - 1])
                } else {
                    self.filteredImages = []
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


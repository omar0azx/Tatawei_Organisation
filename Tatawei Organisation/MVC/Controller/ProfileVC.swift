//
//  ProfileVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class ProfileVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    var accountSettings: [MenuItem] = [
        MenuItem(image: UIImage(systemName: "building.2")!, label: .organisation),
        MenuItem(image: UIImage(systemName: "globe")!, label: .termsAndConditions),
        MenuItem(image: UIImage(systemName: "info.circle.fill")!, label: .about),
        MenuItem(image: UIImage(systemName: "lock.open.rotation")!, label: .resetPassword),
        MenuItem(image: UIImage(systemName: "trash.fill")!, label: .deleteAccount),
        MenuItem(image: UIImage(systemName: "minus.circle.fill")!, label: .logout)
                 ]
    
    var organisationSettings: [MenuItem] = [
        MenuItem(image: UIImage(systemName: "key")!, label: .organisationInvitation),
        MenuItem(image: UIImage(systemName: "person.3.fill")!, label: .organisationTeam)
                 ]
    var isOrganisationSettings = false
    
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var settingsTitle: UILabel!
    
    @IBOutlet weak var officialImage: UIImageView!
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var officialEmail: UILabel!
    @IBOutlet weak var organisationDescription: UILabel!
    @IBOutlet weak var organisationImage: UIImageView!
    
    @IBOutlet weak var backBTN: DesignableButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getOfficialInformation()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        getOfficialInformation()
    }

    
    
    //MARK: - IBAcitions
    
    @IBAction func backBTN(_ sender: UIButton) {
        isOrganisationSettings = false
        settingsTitle.text = "الإعدادات"
        backBTN.isHidden = true
        backBTN.alpha = 0
        tableView.reloadData()
        
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        self.coordinator?.viewEditProfileVC()
    }
    
    func getOfficialInformation() {
        if let official = Official.currentOfficial, let organization = Organization.currentOrganization {
            StorageService.shared.downloadImage(from: "organisations_icons/\(official.organizationID).jpg") { imag, error in
                guard let image = imag else {return}
                self.organisationImage.image = image
            }
            officialImage.image = official.gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg")
            officialName.text = official.name
            officialEmail.text = official.email
            organisationDescription.text = "\(organization.name) - \(official.role == 0 ? "قائد" : "عضو")"
        }
        
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOrganisationSettings {
            return organisationSettings.count
        } else {
            return accountSettings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        if isOrganisationSettings {
            cell.configure(menuItem: organisationSettings[indexPath.row])
        } else {
            cell.configure(menuItem: accountSettings[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var settings = isOrganisationSettings ? organisationSettings[indexPath.row].label : accountSettings[indexPath.row].label
        
        switch settings {
            // Change Language
        case .termsAndConditions:
            if let url = URL(string: "https://drive.google.com/file/d/1nRsDhVX1rqk7Em2VW1vIeIC8OZUzeTdR/view?usp=drive_link") {
                UIApplication.shared.open(url)
            }
            
            // About Us
        case .about:
            print("")
            self.coordinator?.viewAboutVC()
            // Reset Password
        case .resetPassword:
            showCustomAlert(message: "هل أنت متأكد من انك تريد إعادة تعيين كلمة المرور؟", onConfirm: {
                self.coordinator?.viewforgetPasswordVC()
            }, onCancel: {
                print("Action cancelled")
            })
            
            // Delete Account
        case .deleteAccount:
            showCustomAlert(message: "هل أنت متأكد من انك تريد من حذف حسابك ؟", onConfirm: {
                AuthService.shared.deleteAccount { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.coordinator?.viewLoginVC()
                        }
                    }
                }
            }, onCancel: {
                print("Action cancelled")
            })
            
            // Logout
        case .logout:
            showCustomAlert(message: "هل أنت متأكد من انك تريد تسجيل الخروج من حسابك ؟", onConfirm: {
                AuthService.shared.logoutCurrentUser { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.coordinator?.viewLoginVC()
                        }
                    }
                }
            }, onCancel: {
                print("Action cancelled")
            })
        case .organisation:
            isOrganisationSettings = true
            settingsTitle.text = "المنظمة"
            backBTN.isHidden = false
            backBTN.alpha = 1
            tableView.reloadData()
        case .organisationInvitation:
            if let officialRole = Official.currentOfficial?.role, officialRole == 0, let organizationID = Organization.currentOrganization?.id {
                coordinator?.viewInvitationCodeVC(organisationID: organizationID)
            } else {
                let errorView = MessageView(message: "غير مصرح لك بعرض الرمز", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
                return
            }
        case .organisationTeam:
            coordinator?.viewOrganisationTeamVC()
        }
        
    }
    
}

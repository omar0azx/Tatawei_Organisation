//
//  MainCoordinator.swift
//  Tatawei Student
//
//  Created by omar on 19/03/1445 AH.
//

import UIKit
import FirebaseAuth

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Initial View Controller
    func start() {
        viewIntroTataweiVC()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.autoLogin()
        }
    }
    
    func autoLogin() {
        
        if AuthService.shared.checkCurrentUserStatus() ||
        userDefaults.object(forKey: kCURRENTUSER) != nil {
            viewNavigationVC()
        } else {
            viewLoginVC()
        }
    }
    
    func viewRegisterVC() {
        let vc = OrganisationAccountVC.instantiate()
        vc.coordinator = self
        vc.mode = .register
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func viewEditProfileVC() {
        let vc = OrganisationAccountVC.instantiate()
        vc.coordinator = self
        vc.mode = .editProfile
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func viewIntroTataweiVC() {
        let vc = IntroTataweiVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func viewLoginVC() {
        let vc = LoginVC.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func viewNavigationVC() {
        let navigationVC = NavigationVC.instantiate()

        let homeVC = HomeVC.instantiate()
        let opportunityManagementVC = OpportunityManagementVC.instantiate()
        let attendanceVC = AttendanceVC.instantiate()
        let profileVC = ProfileVC.instantiate()
        
        homeVC.coordinator = self
        opportunityManagementVC.coordinator = self
        attendanceVC.coordinator = self
        profileVC.coordinator = self
        navigationVC.coordinator = self
        
        navigationVC.viewControllers = [homeVC, opportunityManagementVC, attendanceVC, profileVC]
        
        self.navigationController.pushViewController(navigationVC, animated: false)
    }
    
    func viewforgetPasswordVC() {
        let vc = ForgetPasswordVC.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func viewUploadLogoVC(data: UploadLogo) {
        let vc = UploadLogoVC.instantiate()
        vc.coordinator = self
        vc.delegate = data
        if let topViewController = navigationController.presentedViewController {
            topViewController.present(vc, animated: true, completion: nil)
        } else {
            navigationController.present(vc, animated: true, completion: nil)
        }
    }
    
    func viewAboutVC() {
        let vc = AboutVC.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
}


//
//  QRScannerVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit
import AVFoundation

class QRScannerVC: UIViewController, Storyboarded {
    
    enum Mode {
        case attendance
        case rating
    }
    
    
    //MARK: - Varibales
    
    var mode: Mode = .attendance
    
    var coordinator: MainCoordinator?
    var opportunityID: String?

    //MARK: - @IBOutlet
    @IBOutlet weak var qrScannerView: QRScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQRScanner()
    }
    //MARK: - @@IBAction
    @IBAction func didPressedCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    
    //MARK: - Functions

    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrScannerView.stopRunning()
    }
    
}
// MARK: - QRScannerViewDelegate
extension QRScannerVC: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error.localizedDescription)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        
        if mode == .attendance {
            let student = StudentRealmService.shared.getStudentById(opportunityID: opportunityID!, studentID: code)
            if code.count != 28 && student?.id != code + opportunityID! {
                let errorView = MessageView(message: "الرمز غير مصرح به او غير صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            } else {
                if student?.isAttended == false {
                    StudentRealmService.shared.updateIsAttendedForStudentInOpportunity(studentID: student!.id, opportunityID: opportunityID!, isAttended: true)
                    let successView = MessageView(message: "تم تحضير الطالب بنجاح", animationName: "correct", animationTime: 1)
                    successView.show(in: self.view)
                } else {
                    let errorView = MessageView(message: "الطالب تم تحضيره مسبقًا", animationName: "warning", animationTime: 1)
                    errorView.show(in: self.view)
                }
            }
        } else {
            if code.count != 28 {
                let errorView = MessageView(message: "الرمز غير مصرح به او غير صحيح", animationName: "warning", animationTime: 1)
                errorView.show(in: self.view)
            } else {
                coordinator?.viewStudentSkillsVC(studentID: code)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            qrScannerView.rescan()
        }
    }
}

extension QRScannerVC {
    
    func showAlert(code: String) {
        
        let alertController = UIAlertController(title: code, message: nil, preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: " خيار واحد ", style: .default) { [weak self] _ in
            UIPasteboard.general.string = code
            self?.qrScannerView.rescan()
        }
        
        
        alertController.addAction(copyAction)
        let searchWebAction = UIAlertAction(title: "خيار اثنين ", style: .default) { [weak self] _ in
            UIApplication.shared.open(URL(string: "https://www.google.com/search?q=\(code)")!, options: [:], completionHandler: nil)
            self?.qrScannerView.rescan()
        }
        
        
        alertController.addAction(searchWebAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.qrScannerView.rescan()
        })
        
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

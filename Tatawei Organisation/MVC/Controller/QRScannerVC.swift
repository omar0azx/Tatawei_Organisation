//
//  QRScannerVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 16/11/2024.
//

import UIKit
import AVFoundation

class QRScannerVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    var coordinator: MainCoordinator?

    //MARK: - @IBOutlet
    @IBOutlet weak var qrScannerView: QRScannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQRScanner()
    }
    //MARK: - @@IBAction
    @IBAction func didPressedView(_ sender: UIButton) {
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
          //  showAlert(code: code)
    }
}


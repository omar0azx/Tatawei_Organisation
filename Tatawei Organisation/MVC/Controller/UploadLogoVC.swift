//
//  UploadLogoVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 09/05/1446 AH.
//

import UIKit

protocol UploadLogo: AnyObject {
    func didGetLogo(image: UIImage)
}

class UploadLogoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storyboarded {
    
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    weak var delegate: UploadLogo?
    
    
    //MARK: - IBOutleats
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBAcitions
    
    @IBAction func chooseLogo(_ sender: UIButton) {
        showImageAlert()
    }
    
    //MARK: - Functions

    //Photo and image
        
        private func showImageAlert() {
            
            let alert = UIAlertController(title: "Take photo From: ", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                self.getPhoto(type: .photoLibrary)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true , completion: nil)
            
        }
        
        private func getPhoto(type: UIImagePickerController.SourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = type
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                dismiss(animated: true, completion: nil)
                self.delegate?.didGetLogo(image: image)
                self.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
            }
        }

}

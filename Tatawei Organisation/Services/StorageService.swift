//
//  StorageService.swift
//  Loop
//
//  Created by omar on 05/08/1444 AH.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    
    static let shared = StorageService()
    private let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?)-> Void) {
        // Ensure image data is valid
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to JPEG data.")
            completion(nil)
            return
        }
        
        // Reference to the storage location
        let storageRef = storage.reference(forURL: "gs://tatawei.appspot.com").child(directory)
        
        // Upload the image data to Firestore storage
        let task = storageRef.putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Retrieve download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url?.absoluteString)
            }
        }
        
        // Remove observers after completion
        task.observe(.success) { _ in
            task.removeAllObservers()
        }
    }

    
    func downloadImage(from path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        var fileName = path.components(separatedBy: "/").last
        let storageRef = storage.reference(withPath: path)
        
        if fileExistsAtPath(path: fileName!) {
            if let contantsOfFile = UIImage(contentsOfFile: fileInDocumentDirectory(fileName: fileName!)) {
                completion(contantsOfFile, nil)
            } else {
                print("could't convert local image")
                completion(nil, NSError(domain: "StorageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to image"]))
            }
        } else {
            
            // Download the image data
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    // Save the image locally
                    StorageService.saveFileLocally(fileData: data as NSData, fileName: fileName!)
                    completion(image, nil)
                } else {
                    print("Error converting data to image.")
                    completion(nil, NSError(domain: "StorageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to image"]))
                }
            }
        }
    }
    
    class func saveFileLocally(fileData: NSData, fileName: String) {
        let docURL = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docURL, atomically: true)
    }
    
    
}

//MARK: - Helpers Or Utilities


func getDocumentURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumentDirectory(fileName: String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentDirectory(fileName: path))
}


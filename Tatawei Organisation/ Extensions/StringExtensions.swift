//
//  StringExtensions.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 28/03/1446 AH.
//

import UIKit

extension String {
    
    // String Extension for grabbing a character at a specific position (return's Character)
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    // Full name validation function
    func isValidFullName() -> Bool {
        // Full name should contain at least two words, each containing alphabetic characters
        let nameRegex = "^[\\p{L}A-Za-z]+(\\s[\\p{L}A-Za-z]+){1,}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
    // Phone number validation function
    func isValidPhoneNumber() -> Bool {
        // Phone number should start with 05 and be exactly 10 digits
        let phoneRegex = "^05[0-9]{8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    // Email validation function
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    // Password validation function
    func isValidPassword() -> Bool {
        // Password should be at least 8 characters, include a number, and a special character
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$&*]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
    
}


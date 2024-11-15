//
//  Storyboarded.swift
//  Tatawei Student
//
//  Created by omar on 19/03/1445 AH.
//

import Foundation

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyViewController"
        let id = String(describing: self)
        
        // load Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that id(identifier), and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}

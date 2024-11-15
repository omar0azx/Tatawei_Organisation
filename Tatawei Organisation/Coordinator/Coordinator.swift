//
//  Coordinator.swift
//  Tatawei Student
//
//  Created by omar on 19/03/1445 AH.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    /// Array to keep tracking of all child coordinators. Most of the time this array will contain only one child coordinator
    var childCoordinators: [Coordinator] { get set }
    
    /// A place to put logic to start the flow.
    func start()
    
    init(_ navigationController: UINavigationController)
}

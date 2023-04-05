//
//  Coordinator.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    // MARK: - Properties
    var childCoordinators: [Coordinator] { get set }
    var finishFlow: ((LaunchInstructor) -> Void)? { get set }
    
    // MARK: - Funcs
    func start()
}

// MARK: - Childs
extension Coordinator {
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else {
            return
        }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func removeAllDependency() {
        guard childCoordinators.isEmpty == false else {
            return
        }
        childCoordinators.removeAll()
    }
}

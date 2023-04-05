//
//  LaunchCoordinator.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import Foundation

final class LaunchCoordinator: Coordinator {
    // MARK: - Child Coordinators
    var childCoordinators: [Coordinator] = []
    
    // MARK: - CoordinatorFinishOutput
    var finishFlow: ((LaunchInstructor) -> Void)?
    
    // MARK: - Private properties
    private let router: Router
    private let factory: Factory
    private let services: Services
    
    // MARK: - Start
    func start() {
        showLaunchController()
    }
    
    // MARK: - Init
    init(router: Router, factory: Factory, services: Services) {
        self.router = router
        self.services = services
        self.factory = factory
    }
}

// MARK: - Private
extension LaunchCoordinator {
    func showLaunchController() {
        let launcViewController = getLaunchController()
        router.setRoot(launcViewController, animated: false)
    }
    
    func getLaunchController() -> LaunchViewController {
        let routes = LaunchPresenterRoutes {
            DispatchQueue.main.async { [weak self] in
                self?.finishFlow?(.main)
            }
        }
        
        let launcViewController = factory.instantiateLaunchViewController(routes: routes)
        return launcViewController
    }
}

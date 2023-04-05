//
//  AppCoordinator.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    let services: Services
    let factory: Factory
    let router: Router
    var window: UIWindow
    var navigationController: UINavigationController
    var launchInstructor: LaunchInstructor
    
    // MARK: - Handlers
    var finishFlow: ((LaunchInstructor) -> Void)?
    
    // MARK: - Init
    init(
        services: Services,
        factory: Factory,
        router: Router,
        launchInstructor: LaunchInstructor,
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.services = services
        self.factory = factory
        self.router = router
        self.window = window
        self.launchInstructor = launchInstructor
        self.navigationController = navigationController
    }
    
    func start() {
        switch launchInstructor {
            
        case .launch:
            runLaunchFlow()
        case .main:
            runMainFlow()
        }
    }
}

// MARK: - Private
private extension AppCoordinator {
    func runLaunchFlow() {
        let coordinator = self.factory.instantiateLaunchCoordinator(router: self.router)
        coordinator.finishFlow = { [unowned self, weak coordinator] _ in
            self.removeDependency(coordinator)
            self.launchInstructor = LaunchInstructor.main
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    func runMainFlow() {
        print(#function)
    }
}

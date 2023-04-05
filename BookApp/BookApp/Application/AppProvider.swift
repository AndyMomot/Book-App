//
//  AppProvider.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

final class AppProvider {
    // MARK: - Properties
    private let window: UIWindow
    private let rootController: UINavigationController
    private let router: Router
    
    // MARK: - Dependencies
    lazy var services = Services()
    lazy var appCoordinator: AppCoordinator = instantiateApplicationCoordinator(services: services)
    
    // MARK: - Init
    init(
        window: UIWindow,
        rootController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.rootController = rootController
        self.router = RouterImpl(rootController: rootController)
    }
    
    // MARK: - Start
    func start() {
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        
        appCoordinator.start()
    }
}

// MARK: - CoordinatorFactory
extension AppProvider: CoordinatorFactory {
    func instantiateApplicationCoordinator(services: Services) -> AppCoordinator {
        return .init(
            services: services,
            factory: self as Factory,
            router: router,
            launchInstructor: .launch,
            window: window,
            navigationController: rootController
        )
    }
    
    func instantiateLaunchCoordinator(router: Router) -> LaunchCoordinator {
        return .init(router: router, factory: self, services: services)
    }
}

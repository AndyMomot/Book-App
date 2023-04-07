//
//  MainCoordinator.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

final class MainCoordinator: Coordinator {
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
        showLibraryhController()
    }
    
    // MARK: - Init
    init(router: Router, factory: Factory, services: Services) {
        self.router = router
        self.services = services
        self.factory = factory
    }
}

extension MainCoordinator {
    // Library Controller
    func showLibraryhController() {
        let libraryViewController = getLibraryController()
        router.setRoot(libraryViewController, animated: false)
    }
    
    func getLibraryController() -> LibraryViewController {
        let routes = LibraryPresenterRoutes { [weak self] bookId in
            DispatchQueue.main.async { [self] in
                self?.showRecommendedController(bookId: bookId)
            }
        }
        
        return factory.instantiateLibraryViewController(routes: routes)
    }
    
    // Recommended Controller
    func showRecommendedController(bookId: Int) {
        let recommendedController = getRecommendedController(bookId: bookId)
        router.push(recommendedController, animated: true)
    }
    
    func getRecommendedController(bookId: Int) -> RecommendedViewController {
        let routes = RecommendedPresenterRoutes()
        return factory.instantiateRecommendedViewController(bookId: bookId, routes: routes)
    }
}

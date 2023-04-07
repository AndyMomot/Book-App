//
//  Router.swift
//  CHIReviewer
//
//  Created by Андрей on 06.04.2023.
//

import UIKit

protocol Router {
    func setRoot(_ viewController: UIViewController, animated: Bool)
    func setRoot(_ viewControllers: [UIViewController], animated: Bool)
    
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func popToRootModule(animated: Bool)
}

final class RouterImpl {
    // MARK: - Properties
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void]
    
    // MARK: - Init
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
    }
}

// MARK: - Router
extension RouterImpl: Router {
    func setRoot(_ viewController: UIViewController, animated: Bool = true) {
        rootController?.setViewControllers([viewController], animated: animated)
    }
    
    func setRoot(_ viewControllers: [UIViewController], animated: Bool = true) {
        rootController?.setViewControllers(viewControllers, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        rootController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        rootController?.popViewController(animated: animated)
    }
    
    func present(
        _ viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        rootController?.controllerForPresentation.present(viewController,
                                                          animated: animated,
                                                          completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)?) {
        rootController?.controllerForPresentation.dismiss(animated: animated,
                                                          completion: completion)
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = self.rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                self.runCompletion(for: controller)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

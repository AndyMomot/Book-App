//
//  LaunchFactory.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import Foundation

protocol LauncViewControllerFactory {
    func instantiateLaunchViewController(routes: LaunchPresenterRoutes) -> LaunchViewController
}

// MARK: - LauncViewController
extension AppProvider: LauncViewControllerFactory {
    func instantiateLaunchViewController(routes: LaunchPresenterRoutes) -> LaunchViewController {
        let launcViewController = LaunchViewController()
        let presenter = LaunchPresenter(routes: routes)
        
        launcViewController.setPresenter(presenter: presenter)
        presenter.setupView(view: launcViewController)
        
        return launcViewController
    }
    
    
}

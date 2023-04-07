//
//  CoordinatorFactory.swift
//  CHIReviewer
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

protocol CoordinatorFactory {
    func instantiateApplicationCoordinator(services: Services) -> AppCoordinator
    func instantiateLaunchCoordinator(router: Router) -> LaunchCoordinator
    func instantiateMainCoordinator(router: Router) -> MainCoordinator
}

//
//  CoordinatorFactory.swift
//  CHIReviewer
//
//  Created by Illia Khrypunov on 08.02.2023.
//

import Foundation

protocol CoordinatorFactory {
    func instantiateApplicationCoordinator(services: Services) -> AppCoordinator
    func instantiateLaunchCoordinator(router: Router) -> LaunchCoordinator
}

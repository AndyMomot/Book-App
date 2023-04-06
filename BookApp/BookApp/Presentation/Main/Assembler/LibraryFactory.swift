//
//  LibraryFactory.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

protocol LibraryFactory {
    func instantiateLibraryViewController(routes: LibraryPresenterRoutes) -> LibraryViewController
}

// MARK: - LibraryFactory
extension AppProvider: LibraryFactory {
    func instantiateLibraryViewController(routes: LibraryPresenterRoutes) -> LibraryViewController {
        let libraryViewController = LibraryViewController()
        let presenter = LibraryPresenter(routes: routes)
        
        libraryViewController.setPresenter(presenter: presenter)
        presenter.setupView(view: libraryViewController)
        presenter.setupService(service: services)
        
        return libraryViewController
    }
}

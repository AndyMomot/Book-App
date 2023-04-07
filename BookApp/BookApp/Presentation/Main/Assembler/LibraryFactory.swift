//
//  LibraryFactory.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

protocol LibraryFactory {
    func instantiateLibraryViewController(routes: LibraryPresenterRoutes) -> LibraryViewController
    func instantiateRecommendedViewController(bookId: Int, routes: RecommendedPresenterRoutes) -> RecommendedViewController
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
    
    func instantiateRecommendedViewController(bookId: Int, routes: RecommendedPresenterRoutes) -> RecommendedViewController {
        let recommendedViewController = RecommendedViewController()
        let presenter = RecommendedPresenter(routes: routes)
        
        recommendedViewController.setBook(id: bookId)
        recommendedViewController.setPresenter(presenter: presenter)
        presenter.setupView(view: recommendedViewController)
        presenter.setupService(service: services)
        
        return recommendedViewController
    }
}

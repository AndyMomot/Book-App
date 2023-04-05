//
//  LibraryPresenter.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

struct LibraryPresenterRoutes {
    
}

final class LibraryPresenter {
    // MARK: - Internal properties
    private weak var view: LibraryPresenterOutput!
    private var routes: LibraryPresenterRoutes!
    
    // MARK: - Init
    init(routes: LibraryPresenterRoutes) {
        self.routes = routes
    }
    
    func setupView(view: LibraryPresenterOutput) {
        self.view = view
    }
}

extension LibraryPresenter: LibraryPresenterInput {
    
}

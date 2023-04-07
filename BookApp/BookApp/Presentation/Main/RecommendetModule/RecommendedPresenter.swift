//
//  RecommendedPresenter.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import Foundation

struct RecommendedPresenterRoutes {
    
}

final class RecommendedPresenter {
    private weak var view: RecommendedPresenterOutput!
    private var routes: RecommendedPresenterRoutes!
    private var service: Services!
    
    // MARK: - Init
    init(routes: RecommendedPresenterRoutes) {
        self.routes = routes
    }
    
    func setupView(view: RecommendedPresenterOutput) {
        self.view = view
    }
    
    func setupService(service: Services) {
        self.service = service
    }
}

extension RecommendedPresenter: RecommendedPresenterInput {
    
}

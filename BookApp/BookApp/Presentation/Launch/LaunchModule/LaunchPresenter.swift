//
//  LaunchPresenter.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import Foundation

struct LaunchPresenterRoutes {
    var onMain: () -> Void
}

final class LaunchPresenter {
    // MARK: - Internal properties
    private weak var view: LaunchPresenterOutput!
    private var routes: LaunchPresenterRoutes!
    
    // MARK: - Init
    init(routes: LaunchPresenterRoutes) {
        self.routes = routes
    }
    
    func setupView(view: LaunchPresenterOutput) {
        self.view = view
    }
}

extension LaunchPresenter: LaunchPresenterInput {
    func switchToMainFlow() {
        routes.onMain()
    }
}

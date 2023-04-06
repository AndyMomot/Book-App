//
//  LibraryPresenter.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

struct LibraryPresenterRoutes {
    var onDetails: (Book) -> Void
}

final class LibraryPresenter {
    // MARK: - Internal properties
    private weak var view: LibraryPresenterOutput!
    private var routes: LibraryPresenterRoutes!
    private var service: Services!
    
    // MARK: - Init
    init(routes: LibraryPresenterRoutes) {
        self.routes = routes
    }
    
    func setupView(view: LibraryPresenterOutput) {
        self.view = view
    }
    
    func setupService(service: Services) {
        self.service = service
    }
}

extension LibraryPresenter: LibraryPresenterInput {
    func didTapBannerBook(_ book: Book) {
        routes.onDetails(book)
    }
    
    func getBooksData() {
        service.booksService.getBooksData { response, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view.errorWithGettingBooksData(error: error)
                    return
                }
            }
            
            if let response = response {
                DispatchQueue.main.async { [weak self] in
                    self?.view.didGetBooksData(data: response)
                    return
                }
            }
        }
    }
    
    func getBannersData() {
        service.bannersService.getBannerData { response, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view.errorWithGettingBannersData(error: error)
                    return
                }
            }
            
            if let response = response {
                DispatchQueue.main.async { [weak self] in
                    self?.view.didGetBannersData(data: response)
                    return
                }
            }
        }
    }
    
    func getRecommendationsData() {
        service.recommendationsService.getRecommendationData { response, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view.errorWithGettingRecommendationsData(error: error)
                    return
                }
            }
            
            if let response = response {
                DispatchQueue.main.async { [weak self] in
                    self?.view.didGetRecommendationsData(data: response)
                    return
                }
            }
        }
    }
}

//
//  RecommendedPresenter.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import Foundation

struct RecommendedPresenterRoutes {
    
}

struct PageInfo: Hashable {
    // MARK: - Properties
    let imageURL: String
}

final class RecommendedPresenter {
    private weak var view: RecommendedPresenterOutput!
    private var routes: RecommendedPresenterRoutes!
    private var service: Services!
    private var booksData = BooksDataModel(books: [])
    
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
    
    func getBooksData() {
        service.booksService.getBooksData { response, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view.errorWithGettingBooksData(error: error)
                    return
                }
            }
            
            if let response = response {
                var sections: [ListSection] {
                    [BookPageSectionSection(items: response.books, sectionDelegate: self)]
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.view.didGetBooksData(data: response)
                    self?.view.addSections(sections)
                    self?.booksData = response
                    return
                }
            }
        }
    }
    
    func getRecommendedData() {
        service.recommendationsService.getRecommendationData { response, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.view.errorWithGettingRecommendedData(error: error)
                    return
                }
            }
            
            if let response = response {
                DispatchQueue.main.async { [weak self] in
                    self?.view.didGetRecommendedData(data: response)
                    return
                }
            }
        }
    }
}

extension RecommendedPresenter: BookPageSectionDelegate {
    func bookPageSection(_ section: BookPageSectionSection, itemIndexChanged index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let book = self.booksData.books[index]
            self.view.setPageInfo(book)
        }
    }
}

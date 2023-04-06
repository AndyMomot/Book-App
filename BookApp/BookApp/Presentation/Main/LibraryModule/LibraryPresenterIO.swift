//
//  LibraryPresenterIO.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import Foundation

protocol LibraryPresenterInput: AnyObject {
    func getBooksData()
    func getBannersData()
    func getRecommendationsData()
    func didTapBannerBook(_ book: Book)
}

protocol LibraryPresenterOutput: AnyObject {
    // Sussecc
    func didGetBannersData(data: BannersDataModel)
    func didGetBooksData(data: BooksDataModel)
    func didGetRecommendationsData(data: RecommendationDataModel)
    
    // Error
    func errorWithGettingBannersData(error: Error)
    func errorWithGettingBooksData(error: Error)
    func errorWithGettingRecommendationsData(error: Error)
}

//
//  RecommendedPresenterIO.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import Foundation

protocol RecommendedPresenterInput: AnyObject {
    func getBooksData()
    func getRecommendedData()
}

protocol RecommendedPresenterOutput: AnyObject {
    func addSections(_ sections: [ListSection])
    func setPageInfo(_ book: Book)
    
    // Success
    func didGetBooksData(data: BooksDataModel)
    func didGetRecommendedData(data: RecommendationDataModel)
    
    // Error
    func errorWithGettingBooksData(error: Error)
    func errorWithGettingRecommendedData(error: Error)
}

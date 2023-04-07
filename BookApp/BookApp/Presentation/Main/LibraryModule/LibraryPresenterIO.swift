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
    func didTapBannerBook(_ bookId: Int)
}

protocol LibraryPresenterOutput: AnyObject {
    // Sussecc
    func didGetBannersData(data: BannersDataModel)
    func didGetBooksData(data: BooksDataModel)
    
    // Error
    func errorWithGettingBannersData(error: Error)
    func errorWithGettingBooksData(error: Error)
}

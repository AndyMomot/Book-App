//
//  Services.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import Foundation

final class Services {
    // MARK: - Poperties
    lazy var booksService = BooksData()
    lazy var bannersService = BannerData()
    lazy var recommendationsService = RecommendationData()
}

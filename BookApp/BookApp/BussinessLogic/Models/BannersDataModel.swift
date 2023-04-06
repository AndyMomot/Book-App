//
//  BannersDataModel.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

// MARK: - BannersDataModel
struct BannersDataModel: Codable {
    let topBannerSlides: [TopBannerSlide]

    enum CodingKeys: String, CodingKey {
        case topBannerSlides = "top_banner_slides"
    }
}

// MARK: - TopBannerSlide
struct TopBannerSlide: Codable {
    let id, bookID: Int
    let cover: String

    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case cover
    }
}

//
//  RecommendationDataModel.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

// MARK: - RecommendationDataModel
struct RecommendationDataModel: Codable {
    let youWillLikeSection: [Int]

    enum CodingKeys: String, CodingKey {
        case youWillLikeSection = "you_will_like_section"
    }
}

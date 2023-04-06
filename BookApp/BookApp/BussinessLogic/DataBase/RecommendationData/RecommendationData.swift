//
//  RecommendationData.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

struct RecommendationData {
    func getRecommendationData(complerion: (RecommendationDataModel?, Error?) -> Void) {
        if let jsonURL = Bundle.main.url(forResource: "RecommendationJSON", withExtension: "json") {
            
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let jsonDecoder = JSONDecoder()
                let recommendations = try jsonDecoder.decode(RecommendationDataModel.self, from: jsonData)
                complerion(recommendations, nil)
            } catch let error {
                debugPrint("Could not fetch recommendations data! Error:", error.localizedDescription)
                complerion(nil, error)
            }
        }
    }
}

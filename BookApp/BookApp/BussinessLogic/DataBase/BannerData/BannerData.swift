//
//  BannerData.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

struct BannerData {
    func getBannerData(complerion: (BannersDataModel?, Error?) -> Void) {
        if let jsonURL = Bundle.main.url(forResource: "BannerJSON", withExtension: "json") {
            
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let jsonDecoder = JSONDecoder()
                let banners = try jsonDecoder.decode(BannersDataModel.self, from: jsonData)
                complerion(banners, nil)
            } catch let error {
                debugPrint("Could not fetch banners data! Error:", error.localizedDescription)
                complerion(nil, error)
            }
        }
    }
}

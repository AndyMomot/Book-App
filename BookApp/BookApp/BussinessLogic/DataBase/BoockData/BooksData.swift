//
//  BooksData.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

struct BooksData {
    func getBooksData(complerion: (BooksDataModel?, Error?) -> Void) {
        if let jsonURL = Bundle.main.url(forResource: "BooksJSON", withExtension: "json") {
            
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let jsonDecoder = JSONDecoder()
                let books = try jsonDecoder.decode(BooksDataModel.self, from: jsonData)
                complerion(books, nil)
            } catch let error {
                debugPrint("Could not fetch books data! Error:", error.localizedDescription)
                complerion(nil, error)
            }
        }
    }
}

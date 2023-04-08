//
//  BooksDataModel.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import Foundation

// MARK: - BooksDataModel
struct BooksDataModel: Codable {
    let books: [Book]
}

// MARK: - Book
struct Book: Codable, Hashable {
    let id: Int
    let name, author, summary, genre: String
    let coverURL: String
    let views, likes, quotes: String

    enum CodingKeys: String, CodingKey {
        case id, name, author, summary, genre
        case coverURL = "cover_url"
        case views, likes, quotes
    }
}

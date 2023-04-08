//
//  NSObject+Identifier.swift
//  BookApp
//
//  Created by Андрей on 08.04.2023.
//

import Foundation

extension NSObject {
    static var identifier: String { "\(String(describing: Self.self))ID" }
}

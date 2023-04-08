//
//  CollectionView+Register.swift
//  BookApp
//
//  Created by Андрей on 08.04.2023.
//

import UIKit

extension UICollectionView {
    final func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
}

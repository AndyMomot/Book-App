//
//  ListSection.swift
//  BookApp
//
//  Created by Андрей on 08.04.2023.
//

import Foundation

import UIKit

class ListSection {
    // MARK: - Properties
    var items: [AnyHashable]
    var sectionID: AnyHashable { ObjectIdentifier(self) }

    // MARK: - Init
    init(items: [AnyHashable]) {
        self.items = items
    }
    
    // MARK: - Public methods
    func setUp(for collectionView: UICollectionView) {
        assertionFailure("You should override this method to provide a list set up")
    }
    
    func createLayoutSection() -> NSCollectionLayoutSection {
        assertionFailure("You should override this method to provide a specific layout for your section")
        return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(.zero), heightDimension: .absolute(.zero))))
    }
    
    func supplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        nil
    }
    
    func configuredCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        nil
    }
}

// MARK: - Hashablw
extension ListSection: Hashable {
    static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        return lhs.sectionID == rhs.sectionID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sectionID)
    }
}

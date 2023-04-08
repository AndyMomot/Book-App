//
//  BookPageSection.swift
//  BookApp
//
//  Created by Андрей on 08.04.2023.
//

import UIKit

protocol BookPageSectionDelegate: AnyObject {
    func bookPageSection(_ section: BookPageSectionSection, itemIndexChanged index: Int)
}

class BookPageSectionSection: ListSection {
    // MARK: - Properties
    weak var sectionDelegate: BookPageSectionDelegate?
    
    // MARK: - Init
    init(items: [AnyHashable], sectionDelegate: BookPageSectionDelegate? = nil) {
        self.sectionDelegate = sectionDelegate
        super.init(items: items)
    }
    
    // MARK: - Override methods
    override func setUp(for collectionView: UICollectionView) {
        collectionView.register(BannerBookCollectionViewCell.self)
    }
    
    override func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 0
        section.contentInsets.top = 20
    
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            guard let page = items.firstIndex(where: { $0.frame.minX - offset.x > .zero  }) else {
                return
            }
            self.sectionDelegate?.bookPageSection(self, itemIndexChanged: page)
            
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.06
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }

        return section
    }
    
    override func configuredCell(collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? {
        
        let cell: BannerBookCollectionViewCell? = collectionView.dequeueReusableCell(for: indexPath)
        
        if let book = item as? Book {
            cell?.configure(withImageURL: book.coverURL)
        }
        
        return cell
    }
}

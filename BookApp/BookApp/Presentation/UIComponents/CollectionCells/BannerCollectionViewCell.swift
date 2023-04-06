//
//  BannerCollectionViewCell.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    private var bacgrounImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        bacgrounImageView.image = nil
    }
    
    func updateCell(image: UIImage) {
        self.bacgrounImageView.image = image
    }
}

private extension BannerCollectionViewCell {
    func initialSetup() {
        setupUI()
        setupLayout()
        setupActions()
    }
    
    func setupUI() {
        bacgrounImageView.contentMode = .scaleAspectFill
        bacgrounImageView.clipsToBounds = true
        bacgrounImageView.layer.cornerRadius = 10
    }
    
    func setupLayout() {
        contentView.addSubview(bacgrounImageView, constraints: [
            bacgrounImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bacgrounImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bacgrounImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bacgrounImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setupActions() {
        
    }
}

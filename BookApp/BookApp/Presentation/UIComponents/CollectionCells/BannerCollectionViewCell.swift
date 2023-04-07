//
//  BannerCollectionViewCell.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    private var bacgrounImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    
    var isBackgrounImageNil: Bool {
        bacgrounImageView.image == nil
    }
    
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
        DispatchQueue.main.async { [weak self] in
            self?.bacgrounImageView.image = image
        }
    }
    
    func showLoading() {
        self.activityIndicator.isHidden = false
        activityIndicator.alpha = 1
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.activityIndicator.alpha = 0
            self?.activityIndicator.isHidden = true
        }
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
}

private extension BannerCollectionViewCell {
    func initialSetup() {
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 10
        
        bacgrounImageView.contentMode = .scaleAspectFill
        bacgrounImageView.clipsToBounds = true
        bacgrounImageView.layer.cornerRadius = 10
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        activityIndicator.alpha = 0
        activityIndicator.isHidden = true

    }
    
    func setupLayout() {
        contentView.addSubview(bacgrounImageView, constraints: [
            bacgrounImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bacgrounImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bacgrounImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bacgrounImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        bacgrounImageView.addSubview(activityIndicator, constraints: [
            activityIndicator.centerXAnchor.constraint(equalTo: bacgrounImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bacgrounImageView.centerYAnchor)
        ])
    }
}

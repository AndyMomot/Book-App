//
//  BannerBookCollectionViewController.swift
//  BookApp
//
//  Created by Андрей on 08.04.2023.
//

import UIKit
import Kingfisher

protocol BannerBookCollectionVIewCellDelegate: AnyObject {
    func cellTaped()
}

class BannerBookCollectionViewCell: UICollectionViewCell {
    weak var delegate: BannerBookCollectionVIewCellDelegate?
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lazy properties
    private var bookCoverImageView = UIImageView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        bookCoverImageView.image = nil
    }
    
    // MARK: - Public methods
    func configure(withImageURL: String) {
        let size = contentView.frame.size
        showLoading()
        downloadImage(from: withImageURL, withSize: size) { [weak self] image in
            self?.bookCoverImageView.image = image
            if self?.bookCoverImageView.image != nil {
                self?.hideLoading()
            }
        }
        
    }
}

private extension BannerBookCollectionViewCell {
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

// MARK: - Private methods
private extension BannerBookCollectionViewCell {
    func initialSetup() {
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        contentView.layer.shadowRadius = 4.0
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 16
        
        bookCoverImageView.contentMode = .scaleAspectFill
        bookCoverImageView.clipsToBounds = true
        bookCoverImageView.layer.cornerRadius = 16
        bookCoverImageView.backgroundColor = .lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
        bookCoverImageView.addGestureRecognizer(tapGesture)
    }
    
    func setupLayout() {
        contentView.addSubview(bookCoverImageView, constraints: [
            bookCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookCoverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        bookCoverImageView.addSubview(activityIndicator, constraints: [
            activityIndicator.centerXAnchor.constraint(equalTo: bookCoverImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bookCoverImageView.centerYAnchor)
        ])
    }
    
    @objc func imageTaped(_ sender: UITapGestureRecognizer) {
        delegate?.cellTaped()
    }
}

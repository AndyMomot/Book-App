//
//  BookCollectionViewCell.swift
//  BookApp
//
//  Created by Андрей on 06.04.2023.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    // MARK: - Public properties
    var cellTapped: ((Int) -> Void)?
    
    // MARK: - Private properties
    private var bookCoverImageView = UIImageView()
    private var bookTitleLabel = UILabel()
    private var bookId: Int? = nil
    private let activityIndicator = UIActivityIndicatorView()
    
    var isBookCoverImageNil: Bool {
        bookCoverImageView.image == nil
    }
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
        bookTitleLabel.text = ""
    }
    
    // MARK: - Public functions
    func updateCell(image: UIImage, title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.bookCoverImageView.image = image
            self?.bookTitleLabel.text = title
        }
    }
    
    func updateCell(title: String, bookId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.bookTitleLabel.text = title
            self?.bookId = bookId
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

// MARK: - Private functions
private extension BookCollectionViewCell {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard bookId != nil else { return }
        cellTapped?(bookId!)
    }
}

// MARK: - Setup
private extension BookCollectionViewCell {
    func initialSetup() {
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        bookCoverImageView.contentMode = .scaleAspectFill
        bookCoverImageView.clipsToBounds = true
        bookCoverImageView.layer.cornerRadius = 10
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bookCoverImageView.isUserInteractionEnabled = true
        bookCoverImageView.addGestureRecognizer(tapGestureRecognizer)
        
        bookCoverImageView.addSubview(activityIndicator, constraints: [
            activityIndicator.centerXAnchor.constraint(equalTo: bookCoverImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bookCoverImageView.centerYAnchor)
        ])
        
        bookTitleLabel.font = FontFamily.NunitoSans.semiBold.font(size: 16)
        bookTitleLabel.textColor = .lightGray.withAlphaComponent(0.7)
        bookTitleLabel.numberOfLines = 0
    }
    
    func setupLayout() {
        contentView.addSubview(bookCoverImageView, constraints: [
            bookCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookCoverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookCoverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75)
        ])
        
        contentView.addSubview(bookTitleLabel, constraints: [
            bookTitleLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 4),
            bookTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//
//  RecommendedView.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import UIKit

protocol RecommendedViewDelegate: AnyObject {
    func backButtonClick()
}

final class RecommendedView: UIView {
    // MARK: - Delegate
    private weak var delegate: RecommendedViewDelegate?
    
    // MARK: - UI Components
    private var scrollView = UIScrollView()
    private let contentView = UIView()
    private var backButton = UIButton()
    
    private let bannerLayout = UICollectionViewFlowLayout()
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerLayout
    )
    private var bookNameLabel = UILabel()
    private var bookAuthorLabel = UILabel()
    private let bookContentView = UIView()
    
    private var viewsNumberLabel = UILabel()
    private var readersLabel = UILabel()
    private var viewsNumberStack = UIStackView()
    
    private var likesNumberLabel = UILabel()
    private var likesLabel = UILabel()
    private var likesNumberStack = UIStackView()
    
    private var quotesNumberLabel = UILabel()
    private var quotesLabel = UILabel()
    private var quotesNumberStack = UIStackView()
    
    private var genreNameLabel = UILabel()
    private var genreLabel = UILabel()
    private var genreNameStack = UIStackView()

    private var indicatorsStack = UIStackView()
    
    private var topDevider = UIView()
    private var summaryLabel = UILabel()
    private var summaryDescriptionLabel = UILabel()
    private var bottomDevider = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    // MARK: - Delegate
    func setDelegate(delegate: RecommendedViewDelegate) {
        self.delegate = delegate
    }
}

private extension RecommendedView {
    @objc func backButtonClick(sender: UIButton) {
        delegate?.backButtonClick()
    }
}

private extension RecommendedView {
    func initialSetup() {
        setupUI()
        setupLayout()
        setupActions()
    }
    
    func setupUI() {
        backgroundColor = XCAsset.Colors.purpleColor.color
        // Scroll View
        scrollView.backgroundColor = XCAsset.Colors.purpleColor.color
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.showsVerticalScrollIndicator = false
        // Back Batton
        let backButtonImage = UIImage(named: "chevron.left")
        backButton.setImage(backButtonImage, for: .normal)
        backButton.sizeToFit()
        // Banner Collection
        bannerCollectionView.backgroundColor = .white.withAlphaComponent(0.1)
        // Book name
        bookNameLabel.text = "If It’s Only Love"
        bookNameLabel.textColor = .white
        bookNameLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        // Book Author
        bookAuthorLabel.text = "Zoey Evers"
        bookAuthorLabel.textColor = .white.withAlphaComponent(0.8)
        bookAuthorLabel.font = FontFamily.NunitoSans.bold.font(size: 14)
        // Book Content
        bookContentView.backgroundColor = .white
        bookContentView.layer.cornerRadius = 20
        // Indicators
        viewsNumberLabel.text = "22.2k"
        readersLabel.text = "Readers"
        
        likesNumberLabel.text = "10.4k"
        likesLabel.text = "Likes"
        
        quotesNumberLabel.text = "32.5k"
        quotesLabel.text = "Quotes"
        
        genreNameLabel.text = "Romance"
        genreLabel.text = "Genre"
        
        indicatorsStack.axis = .horizontal
        indicatorsStack.distribution = .equalSpacing
        
        [viewsNumberLabel, likesNumberLabel, quotesNumberLabel, genreNameLabel].forEach({
            $0.textColor = .black
            $0.font = FontFamily.NunitoSans.bold.font(size: 18)
        })
        
        [readersLabel, likesLabel, quotesLabel, genreLabel].forEach({
            $0.textColor = XCAsset.Colors.secondaryColor.color
            $0.font = FontFamily.NunitoSans.semiBold.font(size: 12)
        })
        
        
        [viewsNumberLabel, readersLabel].forEach({viewsNumberStack.addArrangedSubview($0)})
        [likesNumberLabel, likesLabel].forEach({likesNumberStack.addArrangedSubview($0)})
        [quotesNumberLabel, quotesLabel].forEach({quotesNumberStack.addArrangedSubview($0)})
        [genreNameLabel, genreLabel].forEach({genreNameStack.addArrangedSubview($0)})
        
        [viewsNumberStack, likesNumberStack,
         quotesNumberStack, genreNameStack].forEach({
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fillProportionally
            indicatorsStack.addArrangedSubview($0)
        })
        
        topDevider.backgroundColor = XCAsset.Colors.secondaryColor.color
        
        summaryLabel.text = L10n.RecommendedScreen.summary
        summaryLabel.textColor = .black
        summaryLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        
        summaryDescriptionLabel.text = """
        According to researchers at Duke University, habits account for about 40 percent of our behaviors on any given day. Your life today is essentially the sum of your habits. How in shape or out of shape you are? A result of your habits. How happy or unhappy you are? A result of your habits. How successful or unsuccessful you are? A result of your habits.
        """
        summaryDescriptionLabel.textColor = XCAsset.Colors.darkGrayColor.color
        summaryDescriptionLabel.font = FontFamily.NunitoSans.semiBold.font(size: 14)
        summaryDescriptionLabel.numberOfLines = 0
        
        bottomDevider.backgroundColor = XCAsset.Colors.secondaryColor.color
    }
    
    func setupLayout() {
        addSubview(scrollView, constraints: [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        scrollView.addSubview(contentView, constraints: [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentView.addSubview(backButton, constraints: [
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        contentView.addSubview(bannerCollectionView, constraints: [
            bannerCollectionView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor,
                constant: 13),
            bannerCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(
                equalTo: bannerCollectionView.widthAnchor,
                multiplier: 0.67)
        ])
        
        contentView.addSubview(bookNameLabel, constraints: [
            bookNameLabel.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 16),
            bookNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        contentView.addSubview(bookAuthorLabel, constraints: [
            bookAuthorLabel.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 4),
            bookAuthorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        contentView.addSubview(bookContentView, constraints: [
            bookContentView.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 18),
            bookContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        bookContentView.addSubview(indicatorsStack, constraints: [
            indicatorsStack.topAnchor.constraint(equalTo: bookContentView.topAnchor, constant: 21),
            indicatorsStack.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor, constant: 35),
            indicatorsStack.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -35)
        ])
        
        bookContentView.addSubview(topDevider, constraints: [
            topDevider.topAnchor.constraint(equalTo: indicatorsStack.bottomAnchor, constant: 10),
            topDevider.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor, constant: 16),
            topDevider.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -16),
            topDevider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        bookContentView.addSubview(summaryLabel, constraints: [
            summaryLabel.topAnchor.constraint(equalTo: topDevider.bottomAnchor, constant: 16),
            summaryLabel.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor, constant: 16)
        ])
        
        bookContentView.addSubview(summaryDescriptionLabel, constraints: [
            summaryDescriptionLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            summaryDescriptionLabel.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor, constant: 16),
            summaryDescriptionLabel.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -16)
        ])
        
        bookContentView.addSubview(bottomDevider, constraints: [
            bottomDevider.topAnchor.constraint(equalTo: summaryDescriptionLabel.bottomAnchor, constant: 16),
            bottomDevider.leadingAnchor.constraint(equalTo: bookContentView.leadingAnchor, constant: 16),
            bottomDevider.trailingAnchor.constraint(equalTo: bookContentView.trailingAnchor, constant: -16),
            bottomDevider.heightAnchor.constraint(equalToConstant: 1),
            bottomDevider.bottomAnchor.constraint(equalTo: bookContentView.bottomAnchor, constant: -16)
        ])
        
        //.bottomAnchor.constraint(equalTo: bookContentView.bottomAnchor, constant: -16)
        
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
    }
}

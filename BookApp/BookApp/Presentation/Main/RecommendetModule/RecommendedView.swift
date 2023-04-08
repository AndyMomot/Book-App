//
//  RecommendedView.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import UIKit

protocol RecommendedViewDelegate: AnyObject {
    func backButtonClick()
    func readNowClick()
    func didTapRecommendedBook(_ bookId: Int)
}

final class RecommendedView: UIView {
    // MARK: - Delegate
    private weak var delegate: RecommendedViewDelegate?
    private var booksData = [Book]()
    private var recommendenData = [Int]()
    
    // MARK: - UI Components
    private var scrollView = UIScrollView()
    private let contentView = UIView()
    private var backButton = UIButton()
    
    lazy var bannerCollectionView = ListCollectionView()
    
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
    
    private var youWillLikeLabel = UILabel()
    private let recommendedLayout = UICollectionViewFlowLayout()
    private lazy var recommendedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: recommendedLayout
    )
    
    private var readNowButton = UIButton()
    
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
    
    func setbannerCollectionViewDelegate(_ delegate: ListCollectionViewDelegate) {
        bannerCollectionView.listDelegate = delegate
    }
    
    func updateBooksData(_ data: [Book]) {
        booksData = data
        bannerCollectionView.reloadData()
    }
    
    func updateRecommendedData(_ data: [Int]) {
        recommendenData = data
        recommendedCollectionView.reloadData()
    }
    
    func scrollBannerCellToItem(to index: Int, animated: Bool) {
        let index = IndexPath.init(item: index, section: 0)
        bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }
    
    func setPageInfo(_ book: Book) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bookNameLabel.text = book.name
            self.bookAuthorLabel.text = book.author
            self.viewsNumberLabel.text = book.views
            self.likesNumberLabel.text = book.likes
            self.quotesNumberLabel.text = book.quotes
            self.genreNameLabel.text = book.genre
            self.summaryDescriptionLabel.text = book.summary
        }
    }
}

private extension RecommendedView {
    @objc func backButtonClick(sender: UIButton) {
        delegate?.backButtonClick()
    }
    
    @objc func readNowClick(sender: UIButton) {
        delegate?.readNowClick()
    }
    
    func getRecommendedBook(at indexPath: IndexPath) -> Book? {
        let bookIb = recommendenData[indexPath.row]
        guard let index = booksData.firstIndex(where: {$0.id == bookIb}) else { return nil}
        return booksData[index]
    }
    
    func createRecommendedCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.recommended, for: indexPath
            ) as! BookCollectionViewCell
            
            guard let book = getRecommendedBook(at: indexPath) else { return cell }
            
            cell.updateCell(title: book.name, bookId: book.id)
            cell.cellTapped = { [weak self] bookId in
                guard let self = self else { return }
                self.delegate?.didTapRecommendedBook(bookId)
            }
            
            let size = CGSize(width: frame.width * 0.32, height: collectionView.frame.height)
            downloadImage(
                from: book.coverURL,
                withSize: size,
                placeholder: XCAsset.Images.MainFlow.bannerPlaceholder.image) { image in
                    guard let image = image else { return }
                    cell.updateCell(image: image, title: book.name)
                    collectionView.reloadItems(at: [indexPath])
                }
            return cell
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
        
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsVerticalScrollIndicator = false
        bannerCollectionView.backgroundColor = .clear
        bannerCollectionView.isScrollEnabled = false
        
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
        
        youWillLikeLabel.text = L10n.RecommendedScreen.youWillLike
        youWillLikeLabel.textColor = .black
        youWillLikeLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        
        recommendedLayout.scrollDirection = .horizontal
        recommendedLayout.minimumLineSpacing = 8
        recommendedCollectionView.backgroundColor = .white
        recommendedCollectionView.showsHorizontalScrollIndicator = false
        recommendedCollectionView.showsHorizontalScrollIndicator = false
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.register(
            BookCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CellsId.recommended
        )
        
        readNowButton.backgroundColor = XCAsset.Colors.pinkColor.color
        readNowButton.layer.cornerRadius = 30
        readNowButton.setTitle(L10n.RecommendedScreen.readNow, for: .normal)
        readNowButton.setTitleColor(.white, for: .normal)
        readNowButton.titleLabel?.font = FontFamily.NunitoSans.extraBold.font(size: 16)
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
            backButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonHeight),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonHeight)
        ])
        
        contentView.addSubview(bannerCollectionView, constraints: [
            bannerCollectionView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor,
                constant: Constants.bannerCollectionViewTopPadding),
            bannerCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(
                equalTo: bannerCollectionView.widthAnchor,
                multiplier: Constants.bannerCollectionViewHeight)
        ])
        
        contentView.addSubview(bookNameLabel, constraints: [
            bookNameLabel.topAnchor.constraint(
                equalTo: bannerCollectionView.bottomAnchor,
                constant: Constants.sidePadding),
            bookNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        contentView.addSubview(bookAuthorLabel, constraints: [
            bookAuthorLabel.topAnchor.constraint(
                equalTo: bookNameLabel.bottomAnchor,
                constant: Constants.bookAuthorLabelTopPadding),
            bookAuthorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        contentView.addSubview(bookContentView, constraints: [
            bookContentView.topAnchor.constraint(
                equalTo: bookAuthorLabel.bottomAnchor,
                constant: Constants.bookContentViewTopPadding),
            bookContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        bookContentView.addSubview(indicatorsStack, constraints: [
            indicatorsStack.topAnchor.constraint(
                equalTo: bookContentView.topAnchor,
                constant: Constants.indicatorsStackTopPadding),
            indicatorsStack.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.indicatorsStackSidePadding),
            indicatorsStack.trailingAnchor.constraint(
                equalTo: bookContentView.trailingAnchor,
                constant: -Constants.indicatorsStackSidePadding)
        ])
        
        bookContentView.addSubview(topDevider, constraints: [
            topDevider.topAnchor.constraint(
                equalTo: indicatorsStack.bottomAnchor,
                constant: Constants.topDeviderTopPadding),
            topDevider.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.sidePadding),
            topDevider.trailingAnchor.constraint(
                equalTo: bookContentView.trailingAnchor,
                constant: -Constants.sidePadding),
            topDevider.heightAnchor.constraint(equalToConstant: Constants.deviderHeight)
        ])
        
        bookContentView.addSubview(summaryLabel, constraints: [
            summaryLabel.topAnchor.constraint(
                equalTo: topDevider.bottomAnchor,
                constant: Constants.sidePadding),
            summaryLabel.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.sidePadding)
        ])
        
        bookContentView.addSubview(summaryDescriptionLabel, constraints: [
            summaryDescriptionLabel.topAnchor.constraint(
                equalTo: summaryLabel.bottomAnchor,
                constant: Constants.summaryDescriptionLabelTopPadding),
            summaryDescriptionLabel.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.sidePadding),
            summaryDescriptionLabel.trailingAnchor.constraint(
                equalTo: bookContentView.trailingAnchor,
                constant: -Constants.sidePadding)
        ])
        
        bookContentView.addSubview(bottomDevider, constraints: [
            bottomDevider.topAnchor.constraint(
                equalTo: summaryDescriptionLabel.bottomAnchor,
                constant: Constants.sidePadding),
            bottomDevider.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.sidePadding),
            bottomDevider.trailingAnchor.constraint(
                equalTo: bookContentView.trailingAnchor,
                constant: -Constants.sidePadding),
            bottomDevider.heightAnchor.constraint(equalToConstant: Constants.deviderHeight)
        ])
        
        bookContentView.addSubview(youWillLikeLabel, constraints: [
            youWillLikeLabel.topAnchor.constraint(
                equalTo: bottomDevider.bottomAnchor,
                constant: Constants.sidePadding),
            youWillLikeLabel.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.sidePadding)
        ])
        
        bookContentView.addSubview(recommendedCollectionView, constraints: [
            recommendedCollectionView.topAnchor.constraint(
                equalTo: youWillLikeLabel.bottomAnchor,
                constant: Constants.sidePadding),
            recommendedCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: Constants.recommendedCollectionViewHeight)
        ])
        
        bookContentView.addSubview(readNowButton, constraints: [
            readNowButton.topAnchor.constraint(
                equalTo: recommendedCollectionView.bottomAnchor,
                constant: Constants.readNowButtonTopPadding),
            readNowButton.leadingAnchor.constraint(
                equalTo: bookContentView.leadingAnchor,
                constant: Constants.readNowButtonSidePadding),
            readNowButton.trailingAnchor.constraint(
                equalTo: bookContentView.trailingAnchor,
                constant: -Constants.readNowButtonSidePadding),
            readNowButton.heightAnchor.constraint(
                equalTo: readNowButton.widthAnchor,
                multiplier: Constants.readNowButtonHeight),
            readNowButton.bottomAnchor.constraint(
                equalTo: bookContentView.bottomAnchor,
                constant: -Constants.sidePadding)
        ])
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        readNowButton.addTarget(self, action: #selector (readNowClick(sender:)), for: .touchUpInside)
    }
}

// MARK: - UICollectionViewDelegate
extension RecommendedView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension RecommendedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return booksData.count
        } else {
            return recommendenData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            return UICollectionViewCell()
        } else {
            let cell = createRecommendedCell(collectionView, cellForItemAt: indexPath)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecommendedView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return .zero
        } else {
            return CGSize(
                width: frame.width * Constants.bookCellWidth,
                height: collectionView.frame.height)
        }
    }
}

fileprivate enum Constants {
    enum CellsId {
        static let bannerCell = "BannerCell"
        static let recommended = "RecommendedCell"
    }
    static let backButtonHeight: CGFloat = 48
    static let recommendedCollectionViewHeight: CGFloat = 200
    static let sidePadding: CGFloat = 16
    static let readNowButtonTopPadding: CGFloat = 24
    static let readNowButtonSidePadding: CGFloat = 48
    static let readNowButtonHeight: CGFloat = 0.2
    static let deviderHeight: CGFloat = 1
    static let summaryDescriptionLabelTopPadding: CGFloat = 8
    static let topDeviderTopPadding: CGFloat = 10
    static let indicatorsStackSidePadding: CGFloat = 35
    static let indicatorsStackTopPadding: CGFloat = 21
    static let bookContentViewTopPadding: CGFloat = 18
    static let bookAuthorLabelTopPadding: CGFloat = 4
    static let bannerCollectionViewHeight: CGFloat = 0.7
    static let bannerCollectionViewTopPadding: CGFloat = 13
    static let bookCellWidth: CGFloat = 0.32
}

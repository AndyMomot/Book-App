//
//  LibraryView.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

protocol LibraryViewDelegate: AnyObject {
    func updateBannerTimer()
    func didTapBannerBook(_ bookId: Int)
}

final class LibraryView: UIView {
    // MARK: - Private
    private weak var delegate: LibraryViewDelegate?
    private var bannerPageCounter = 0
    
    // MARK: - UI components
    private var scrollView = UIScrollView()
    private let contentView = UIView()
    private let libraryLabel = UILabel()
    
    let bannerLayout = UICollectionViewFlowLayout()
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerLayout
    )
    private var pageControl = UIPageControl()
    
    private var booksData = BooksDataModel(books: [])
    private var bannersData = BannersDataModel(topBannerSlides: [])
    private var recommendationsData = RecommendationDataModel(youWillLikeSection: [])
    
    var didTapVannerCell: (() -> Void)?
    
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
    func setDelegate(delegate: LibraryViewDelegate) {
        self.delegate = delegate
    }
    
    func updateBooksData(_ booksData: BooksDataModel) {
        self.booksData = booksData
        bannerCollectionView.reloadData()
    }
    
    func updateBannerData(_ bannersData: BannersDataModel) {
        self.bannersData = bannersData
        pageControl.numberOfPages = self.bannersData.topBannerSlides.count
        bannerCollectionView.reloadData()
    }
    
    func updateRecommendationsData(_ data: RecommendationDataModel) {
        self.recommendationsData = data
    }
    
    func updateBannerCellImage() {
        if bannerPageCounter < bannersData.topBannerSlides.count {
            scrollBannerCellToItem(to: bannerPageCounter, animated: true)
            pageControl.currentPage = bannerPageCounter
            bannerPageCounter += 1
        } else {
            bannerPageCounter = 0
            pageControl.currentPage = bannerPageCounter
            scrollBannerCellToItem(to: bannerPageCounter, animated: true)
        }
    }
}

// MARK: - Private functions
private extension LibraryView {
    func scrollBannerCellToItem(to index: Int, animated: Bool) {
        let index = IndexPath.init(item: index, section: 0)
        bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }
    
    func getBannerImage(at indexPath: IndexPath) -> String {
        let bannerSlide = bannersData.topBannerSlides[indexPath.row]
        let book = booksData.books.filter({$0.id == bannerSlide.bookID}).first
        let bannerImageURL = book?.coverURL
        return bannerImageURL ?? ""
    }
    
    func updateBannerSlidePozition(_ scrollView: UIScrollView) {
        let point = scrollView.convert(scrollView.bounds.origin, to: bannerCollectionView)
        let indexInt = Int(point.x / scrollView.frame.width)
        let indexDouble = Double(point.x / scrollView.frame.width)
        bannerPageCounter = indexInt
        pageControl.currentPage = indexInt
        
        if indexDouble > Double(bannersData.topBannerSlides.count - 1) {
            bannerPageCounter = 0
            pageControl.currentPage = 0
            scrollBannerCellToItem(to: bannerPageCounter, animated: true)
            delegate?.updateBannerTimer()
        }
        
        if indexDouble < 0 {
            bannerPageCounter = bannersData.topBannerSlides.count - 1
            pageControl.currentPage = bannerPageCounter
            scrollBannerCellToItem(to: bannerPageCounter, animated: true)
            delegate?.updateBannerTimer()
        }
    }
    
    @objc private func cellPressHandler(_ sender: UIGestureRecognizer) {
        didTapVannerCell?()
    }
    
    func createBannerCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.bannerCell, for: indexPath
            ) as! BannerCollectionViewCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellPressHandler))
            cell.addGestureRecognizer(tapGesture)
            
            
            didTapVannerCell = { [weak self] in
                guard let self = self else { return }
                let bookId = self.bannersData.topBannerSlides[indexPath.row].bookID
                self.delegate?.didTapBannerBook(bookId)
            }
            
            let image = getBannerImage(at: indexPath)
            downloadImage(
                from: image,
                withSize: CGSize(width: collectionView.frame.width, height: collectionView.frame.height),
                placeholder: XCAsset.Images.MainFlow.bannerPlaceholder.image
            ) { image in
                guard let image = image else { return }
                cell.updateCell(image: image)
                collectionView.reloadItems(at: [indexPath])
            }
            
            return cell
        }
}

// MARK: - Setup UI
private extension LibraryView {
    func initialSetup() {
        setupUI()
        setupLayout()
        setupActions()
    }
    
    func setupUI() {
        // Self
        backgroundColor = XCAsset.Colors.libraryBacground.color
        // Scroll View
        scrollView.backgroundColor = XCAsset.Colors.libraryBacground.color
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.showsVerticalScrollIndicator = false
        // Library Label
        libraryLabel.text = L10n.LibraryScreen.libraryLabel
        libraryLabel.textColor = XCAsset.Colors.redColor.color
        libraryLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        // Banner Layout
        bannerLayout.scrollDirection = .horizontal
        bannerLayout.minimumLineSpacing = 0
        // Banner Collection View
        bannerCollectionView.backgroundColor = .yellow
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.backgroundColor = XCAsset.Colors.libraryBacground.color
        bannerCollectionView.decelerationRate = .fast
        bannerCollectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CellsId.bannerCell
        )
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        pageControl.numberOfPages = bannersData.topBannerSlides.count
        pageControl.currentPage = 0
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
        
        contentView.addSubview(libraryLabel, constraints: [
            libraryLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.libraryLabelTopPadding),
            libraryLabel.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: Constants.libraryLabelLeadingPadding)
        ])
        
        contentView.addSubview(bannerCollectionView, constraints: [
            bannerCollectionView.topAnchor.constraint(
                equalTo: libraryLabel.bottomAnchor,
                constant: Constants.bannerCollectionViewBottomPadding),
            bannerCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.bannerCollectionViewSidePedding),
            bannerCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.bannerCollectionViewSidePedding),
            bannerCollectionView.heightAnchor.constraint(
                equalTo: bannerCollectionView.widthAnchor,
                multiplier: Constants.bannerCollectionViewHeightIndex),
            bannerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(pageControl, constraints: [
            pageControl.leadingAnchor.constraint(equalTo: bannerCollectionView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: bannerCollectionView.trailingAnchor),
            pageControl.bottomAnchor.constraint(
                equalTo: bannerCollectionView.bottomAnchor,
                constant: Constants.pageControlBottomPadding)
        ])
    }
    
    func setupActions() {
        
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBannerSlidePozition(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDataSource
extension LibraryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bannerCollectionView {
            return bannersData.topBannerSlides.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = createBannerCell(collectionView, cellForItemAt: indexPath)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

fileprivate enum Constants {
    enum CellsId {
        static let bannerCell = "BannerCell"
    }
    
    static let libraryLabelTopPadding: CGFloat = 38
    static let libraryLabelLeadingPadding: CGFloat = 38
    
    static let bannerCollectionViewBottomPadding: CGFloat = 28
    static let bannerCollectionViewSidePedding: CGFloat = 16
    static let bannerCollectionViewHeightIndex: CGFloat = 0.4
    
    static let pageControlBottomPadding: CGFloat = -8
}

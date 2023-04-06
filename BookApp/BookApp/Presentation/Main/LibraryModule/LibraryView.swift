//
//  LibraryView.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

protocol LibraryViewDelegate: AnyObject {
    func updateBannerTimer()
    func didTapBook(_ bookId: Int)
}

final class LibraryView: UIView {
    // MARK: - Private
    private weak var delegate: LibraryViewDelegate?
    private var bannerPageCounter = 0
    
    // MARK: - UI components
    private var scrollView = UIScrollView()
    private let contentView = UIView()
    private let libraryLabel = UILabel()
    
    // MARK: - Banner
    private let bannerLayout = UICollectionViewFlowLayout()
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerLayout
    )
    private var didTapVannerCell: (() -> Void)?
    private var pageControl = UIPageControl()
    
    // MARK: - New Arrivals Books
    private var newArrivalsLabel = UILabel()
    private let arrivalsLayout = UICollectionViewFlowLayout()
    private lazy var arrivalsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: arrivalsLayout
    )
    
    // MARK: - Romance Books
    private var romanceLabel = UILabel()
    private let romanceLayout = UICollectionViewFlowLayout()
    private lazy var romanceCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: romanceLayout
    )
    
    // MARK: - Data
    private var booksData = BooksDataModel(books: [])
    private var arrivesBooks: [Book] {
        let arrivesBooks = booksData.books.filter({$0.genre == Constants.BookGenre.science})
        return arrivesBooks
    }
    private var romanceBooks: [Book] {
        let romanceBooks = booksData.books.filter({$0.genre == Constants.BookGenre.romance})
        return romanceBooks
    }
    
    private var bannersData = BannersDataModel(topBannerSlides: [])
    private var recommendationsData = RecommendationDataModel(youWillLikeSection: [])
    
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
        arrivalsCollectionView.reloadData()
        romanceCollectionView.reloadData()
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
    
    @objc private func bannerCellPressHandler(_ sender: UIGestureRecognizer) {
        didTapVannerCell?()
    }
    
    func createBannerCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.bannerCell, for: indexPath
            ) as! BannerCollectionViewCell
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerCellPressHandler))
            cell.addGestureRecognizer(tapGesture)
            
            didTapVannerCell = { [weak self] in
                guard let self = self else { return }
                let bookId = self.bannersData.topBannerSlides[indexPath.row].bookID
                self.delegate?.didTapBook(bookId)
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
    
    func createArrivalCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.arrivalCell, for: indexPath
            ) as! BookCollectionViewCell
            
            let book = arrivesBooks[indexPath.row]
            cell.updateCell(title: book.name, bookId: book.id)
            cell.cellTapped = { [weak self] bookId in
                guard let self = self else { return }
                self.delegate?.didTapBook(bookId)
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
    
    func createRomanceCell(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.romanceCell, for: indexPath
            ) as! BookCollectionViewCell
            let book = romanceBooks[indexPath.row]
            cell.updateCell(title: book.name, bookId: book.id)
            cell.cellTapped = { [weak self] bookId in
                guard let self = self else { return }
                self.delegate?.didTapBook(bookId)
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

// MARK: - Setup UI
private extension LibraryView {
    func initialSetup() {
        setupUI()
        setupLayout()
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
        
        // Arrivals
        newArrivalsLabel.text = L10n.LibraryScreen.newArrivalsLabel
        newArrivalsLabel.textColor = .white
        newArrivalsLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        
        arrivalsLayout.scrollDirection = .horizontal
        arrivalsLayout.minimumLineSpacing = 8
        arrivalsCollectionView.backgroundColor = XCAsset.Colors.libraryBacground.color
        arrivalsCollectionView.showsHorizontalScrollIndicator = false
        arrivalsCollectionView.showsHorizontalScrollIndicator = false
        arrivalsCollectionView.delegate = self
        arrivalsCollectionView.dataSource = self
        arrivalsCollectionView.register(
            BookCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CellsId.arrivalCell
        )
        
        // Romance
        romanceLabel.text = L10n.LibraryScreen.romanceLabel
        romanceLabel.textColor = .white
        romanceLabel.font = FontFamily.NunitoSans.bold.font(size: 20)
        
        romanceLayout.scrollDirection = .horizontal
        romanceLayout.minimumLineSpacing = 8
        
        romanceCollectionView.backgroundColor = XCAsset.Colors.libraryBacground.color
        romanceCollectionView.showsHorizontalScrollIndicator = false
        romanceCollectionView.showsHorizontalScrollIndicator = false
        romanceCollectionView.delegate = self
        romanceCollectionView.dataSource = self
        romanceCollectionView.register(
            BookCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CellsId.romanceCell
        )
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
                constant: Constants.sidePadding)
        ])
        
        contentView.addSubview(bannerCollectionView, constraints: [
            bannerCollectionView.topAnchor.constraint(
                equalTo: libraryLabel.bottomAnchor,
                constant: Constants.bannerCollectionViewBottomPadding),
            bannerCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding),
            bannerCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sidePadding),
            bannerCollectionView.heightAnchor.constraint(
                equalTo: bannerCollectionView.widthAnchor,
                multiplier: Constants.bannerCollectionViewHeightIndex)
        ])
        
        contentView.addSubview(pageControl, constraints: [
            pageControl.leadingAnchor.constraint(equalTo: bannerCollectionView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: bannerCollectionView.trailingAnchor),
            pageControl.bottomAnchor.constraint(
                equalTo: bannerCollectionView.bottomAnchor,
                constant: Constants.pageControlBottomPadding)
        ])
        
        // Arrivals
        contentView.addSubview(newArrivalsLabel, constraints: [
            newArrivalsLabel.topAnchor.constraint(
                equalTo: bannerCollectionView.bottomAnchor,
                constant: Constants.newArrivalsLabelTopPadding),
            newArrivalsLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding)
        ])
        
        contentView.addSubview(arrivalsCollectionView, constraints: [
            arrivalsCollectionView.topAnchor.constraint(
                equalTo: newArrivalsLabel.bottomAnchor,
                constant: Constants.sidePadding),
            arrivalsCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding),
            arrivalsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            arrivalsCollectionView.heightAnchor.constraint(equalToConstant: Constants.arrivalsCollectionViewHeight)
        ])
        
        // Romance
        contentView.addSubview(romanceLabel, constraints: [
            romanceLabel.topAnchor.constraint(
                equalTo: arrivalsCollectionView.bottomAnchor,
                constant: Constants.romanceLabelTopPadding),
            romanceLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding)
        ])
        
        contentView.addSubview(romanceCollectionView, constraints: [
            romanceCollectionView.topAnchor.constraint(
                equalTo: romanceLabel.bottomAnchor,
                constant: Constants.sidePadding),
            romanceCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sidePadding),
            romanceCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            romanceCollectionView.heightAnchor.constraint(equalToConstant: Constants.arrivalsCollectionViewHeight),
            romanceCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateBannerSlidePozition(scrollView)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: frame.width * 0.32, height: collectionView.frame.height)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LibraryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bannerCollectionView {
            return bannersData.topBannerSlides.count
        } else if collectionView == self.arrivalsCollectionView {
            return arrivesBooks.count
        } else if collectionView == self.romanceCollectionView {
            return romanceBooks.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = createBannerCell(collectionView, cellForItemAt: indexPath)
            return cell
            
        } else if collectionView == self.arrivalsCollectionView {
            let cell = createArrivalCell(collectionView, cellForItemAt: indexPath)
            return cell
            
        } else if collectionView == self.romanceCollectionView {
            let cell = createRomanceCell(collectionView, cellForItemAt: indexPath)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

fileprivate enum Constants {
    enum CellsId {
        static let bannerCell = "BannerCell"
        static let arrivalCell = "ArrivalCell"
        static let romanceCell = "RomanceCell"
    }
    
    enum BookGenre {
        static let romance = "Romance"
        static let science = "Science"
        static let fantasy = "Fantasy"
    }
    
    static let sidePadding: CGFloat = 16
    static let libraryLabelTopPadding: CGFloat = 38
    
    static let bannerCollectionViewBottomPadding: CGFloat = 28
    static let bannerCollectionViewHeightIndex: CGFloat = 0.4
    
    static let pageControlBottomPadding: CGFloat = -3
    static let newArrivalsLabelTopPadding: CGFloat = 35
    static let arrivalsCollectionViewHeight: CGFloat = 200
    static let romanceLabelTopPadding: CGFloat = 26
}

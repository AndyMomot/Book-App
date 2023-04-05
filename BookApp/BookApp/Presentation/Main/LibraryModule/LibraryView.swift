//
//  LibraryView.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

protocol LibraryViewDelegate: AnyObject {
    
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
    private var pageControll = UIPageControl()

    private var customData = [UIImage]()
    
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
    
    func updateBannerCellImage() {
        if bannerPageCounter < customData.count {
            scrollBunnerCellToItem(to: bannerPageCounter, animated: true)
            pageControll.currentPage = bannerPageCounter
            bannerPageCounter += 1
        } else {
            bannerPageCounter = 0
            pageControll.currentPage = bannerPageCounter
            scrollBunnerCellToItem(to: bannerPageCounter, animated: true)
        }
    }
}

// MARK: - Private functions
private extension LibraryView {
    func scrollBunnerCellToItem(to index: Int, animated: Bool) {
        let index = IndexPath.init(item: index, section: 0)
        bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
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
        
        // TODO: - Delete it
        customData = [
            XCAsset.Images.LauncFlow.car.image,
            XCAsset.Images.LauncFlow.car3.image,
            XCAsset.Images.LauncFlow.car2.image
        ]
        
        pageControll.numberOfPages = customData.count
        pageControll.currentPage = 0
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
            libraryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38),
            libraryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
        ])
        
        contentView.addSubview(bannerCollectionView, constraints: [
            bannerCollectionView.topAnchor.constraint(equalTo: libraryLabel.bottomAnchor, constant: 28),
            bannerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bannerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bannerCollectionView.heightAnchor.constraint(equalTo: bannerCollectionView.widthAnchor, multiplier: 0.4),
            bannerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(pageControll, constraints: [
            pageControll.leadingAnchor.constraint(equalTo: bannerCollectionView.leadingAnchor),
            pageControll.trailingAnchor.constraint(equalTo: bannerCollectionView.trailingAnchor),
            pageControll.bottomAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupActions() {
        
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.convert(scrollView.bounds.origin, to: bannerCollectionView)
        let indexInt = Int(point.x / scrollView.frame.width)
        let indexDouble = Double(point.x / scrollView.frame.width)
        bannerPageCounter = indexInt
        pageControll.currentPage = indexInt
        
        if indexDouble > Double(customData.count - 1) {
            bannerPageCounter = 0
            pageControll.currentPage = 0
            scrollBunnerCellToItem(to: bannerPageCounter, animated: true)
        }
        
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
            return customData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.CellsId.bannerCell, for: indexPath
            ) as! BannerCollectionViewCell
            
            let image = self.customData[indexPath.row]
            cell.updateCell(image: image)
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
}

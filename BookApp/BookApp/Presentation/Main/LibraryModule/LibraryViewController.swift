//
//  LibraryViewController.swift
//  BookApp
//
//  Created by Андрей on 05.04.2023.
//

import UIKit

final class LibraryViewController: UIViewController {
    // MARK: - Private properties
    private var presenter: LibraryPresenterInput!
    private var bannerTimer = Timer()
    
    private var booksData = BooksDataModel(books: [])
    private var bannersData = BannersDataModel(topBannerSlides: [])
    
    // MARK: - UI components
    private var contentView = LibraryView()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setDelegate(delegate: self)
        getBooksData()
        getBannersData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBannerCellImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bannerTimer.invalidate()
    }
    
    // MARK: - Presenter
    func setPresenter(presenter: LibraryPresenterInput) {
        self.presenter = presenter
    }
}

// MARK: - Private functions
private extension LibraryViewController {
    func getBooksData() {
        presenter.getBooksData()
    }
    
    func getBannersData() {
        presenter.getBannersData()
    }
    
    func updateBannerCellImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bannerTimer = .scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] timer in
                self.contentView.updateBannerCellImage()
            })
        }
    }
}

// MARK: - LibraryViewDelegate
extension LibraryViewController: LibraryViewDelegate {
    func didTapBook(_ bookId: Int) {
        if !booksData.books.isEmpty {
            guard let book = booksData.books.filter({$0.id == bookId}).first else { return }
            presenter.didTapBannerBook(book)
        }
    }
    
    func updateBannerTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.bannerTimer.invalidate()
            
            guard let self = self else { return }
            self.bannerTimer = .scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] timer in
                self.contentView.updateTimer()
            })
        }
    }
}

// MARK: - LibraryPresenterOutput
extension LibraryViewController: LibraryPresenterOutput {
    // Success
    func didGetBooksData(data: BooksDataModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.booksData = data
            self.contentView.updateBooksData(self.booksData)
        }
    }
    
    func didGetBannersData(data: BannersDataModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bannersData = data
            self.contentView.updateBannerData(self.bannersData)
        }
    }
    
    // Errors
    func errorWithGettingBannersData(error: Error) {
        print(#function)
    }
    
    func errorWithGettingBooksData(error: Error) {
        print(#function)
    }
}

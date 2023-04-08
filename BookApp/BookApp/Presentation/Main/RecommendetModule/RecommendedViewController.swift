//
//  RecommendedViewController.swift
//  BookApp
//
//  Created by Андрей on 07.04.2023.
//

import UIKit

final class RecommendedViewController: UIViewController {

    private var presenter: RecommendedPresenterInput!
    private var contentView = RecommendedView()
    private var bookId: Int!
    private var booksData = [Book]()
    private var recommendenData = [Int]()
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setDelegate(delegate: self)
        contentView.setbannerCollectionViewDelegate(self)
        getBooksData()
        getRecommendedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        contentView.scrollBannerCellToItem(to: bookId, animated: false)
    }
    
    // MARK: - Presenter
    func setPresenter(presenter: RecommendedPresenterInput) {
        self.presenter = presenter
    }
    
    func setBook(id: Int) {
        self.bookId = id
    }
}

private extension RecommendedViewController {
    func getBooksData() {
        presenter.getBooksData()
    }
    
    func getRecommendedData() {
        presenter.getRecommendedData()
    }
    
    func applySnapshot(sections: [ListSection]) {
        var snapshot = contentView.bannerCollectionView.diffableDataSource.snapshot()
        snapshot.deleteAllItems()
        
        sections.forEach { section in
            section.setUp(for: contentView.bannerCollectionView)
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        
        contentView.bannerCollectionView.diffableDataSource.apply(snapshot)
    }
}

extension RecommendedViewController: ListCollectionViewDelegate {
    
    func listCollectionView(_ listCollectionView: ListCollectionView, didSelect item: AnyHashable, at indexPath: IndexPath) {
        // Cell selected
    }
}

extension RecommendedViewController: RecommendedViewDelegate {
    func readNowClick() {
        print(#function)
    }
    
    func didTapRecommendedBook(_ bookId: Int) {
        guard let index = booksData.firstIndex(where: {$0.id == bookId}) else { return }
        contentView.scrollBannerCellToItem(to: index, animated: true)
    }
    
    func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecommendedViewController: RecommendedPresenterOutput {
    func setPageInfo(_ book: Book) {
        contentView.setPageInfo(book)
    }
    
    
    func addSections(_ sections: [ListSection]) {
        applySnapshot(sections: sections)
    }
    
    // Success
    func didGetBooksData(data: BooksDataModel) {
        self.booksData = data.books
        contentView.updateBooksData(booksData)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let index = self?.booksData.firstIndex(where: {$0.id == self?.bookId}) else { return }
            self?.contentView.scrollBannerCellToItem(to: index, animated: true)
        }
    }
    
    func didGetRecommendedData(data: RecommendationDataModel) {
        self.recommendenData = data.youWillLikeSection
        contentView.updateRecommendedData(recommendenData)
    }
    
    // Error
    func errorWithGettingBooksData(error: Error) {
        print(error.localizedDescription)
    }
    
    func errorWithGettingRecommendedData(error: Error) {
        print(error.localizedDescription)
    }
}

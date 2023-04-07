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
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setDelegate(delegate: self)
    }
    
    // MARK: - Presenter
    func setPresenter(presenter: RecommendedPresenterInput) {
        self.presenter = presenter
    }
    
    func setBook(id: Int) {
        self.bookId = id
    }
}

extension RecommendedViewController: RecommendedViewDelegate {
    func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension RecommendedViewController: RecommendedPresenterOutput {
    
}

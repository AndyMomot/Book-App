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
    private var timer = Timer()
    
    // MARK: - UI components
    private var contentView = LibraryView()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setDelegate(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBannerCellImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    // MARK: - Presenter
    func setPresenter(presenter: LibraryPresenterInput) {
        self.presenter = presenter
    }
}

// MARK: - Private functions
private extension LibraryViewController {
    func updateBannerCellImage() {
        timer = .scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.contentView.updateBannerCellImage()
        })
    }
}

// MARK: - LibraryViewDelegate
extension LibraryViewController: LibraryViewDelegate {
    
}

// MARK: - LibraryPresenterOutput
extension LibraryViewController: LibraryPresenterOutput {
    
}

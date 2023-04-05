//
//  LaunchViewController.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    private var presenter: LaunchPresenterInput!
    
    // MARK: - Subviews
    private let contentView = LaunchView()
    
    // MARK: - Lifycycle
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setDelegate(delegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.updateFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.animateProgressView()
    }
    
    // MARK: - Presenter
    func setPresenter(presenter: LaunchPresenterInput) {
        self.presenter = presenter
    }
}

extension LaunchViewController: LaunchViewDelegate {
    func switchToMainFlow() {
        presenter.switchToMainFlow()
    }
    
    
}

extension LaunchViewController: LaunchPresenterOutput {
    
}

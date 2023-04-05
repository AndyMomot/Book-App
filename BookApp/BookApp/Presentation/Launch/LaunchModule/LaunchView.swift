//
//  LaunchView.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

protocol LaunchViewDelegate: AnyObject {
    func switchToMainFlow()
}

final class LaunchView: UIView {
    // MARK: - Private UI Components
    private var backgroundImageView = UIImageView()
    private var heartsImageView = UIImageView()
    
    private var bookAppLogoLabel = UILabel()
    private var welcomeImageLabel = UILabel()
    
    private var labelsStackView = UIStackView()
    private var labelsContainer = UIView()
    
    private var progressView = UIProgressView()
    private let progress = Progress(totalUnitCount: 100)
    
    private weak var delegate: LaunchViewDelegate?

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
    func setDelegate(delegate: LaunchViewDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public
    func updateFrames() {
        initialSetup()
    }
    
    func animateProgressView() {
        let timeInterval = Constants.progerssTime / 100
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            guard self.progress.isFinished == false else {
                timer.invalidate()
                self.delegate?.switchToMainFlow()
                return
            }
            
            self.progress.completedUnitCount += 1
            let progressValue = Float(self.progress.fractionCompleted)
            self.progressView.setProgress(progressValue, animated: true)
        }
    }
}

// MARK: - Setup
private extension LaunchView {
    func initialSetup() {
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        backgroundColor = .systemGray
        backgroundImageView.image = XCAsset.Images.LauncFlow.launchRedBackground.image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        heartsImageView.image = XCAsset.Images.LauncFlow.launchHeartsBackground.image
        heartsImageView.contentMode = .scaleAspectFit
        heartsImageView.clipsToBounds = true
        
        bookAppLogoLabel.text = L10n.LauncScreen.bookApp
        bookAppLogoLabel.font = FontFamily.Georgia.boldItalic.font(size: 52)
        bookAppLogoLabel.textColor = XCAsset.Colors.pinkColor.color
        
        welcomeImageLabel.text = L10n.LauncScreen.welcomeText
        welcomeImageLabel.font = FontFamily.NunitoSans.black.font(size: 24)
        welcomeImageLabel.textColor = .white
        
        labelsStackView.axis = .vertical
        labelsStackView.spacing = Constants.labelsStackViewSpacing
        labelsStackView.alignment = .center
        labelsStackView.distribution = .fillProportionally
        labelsStackView.addArrangedSubview(bookAppLogoLabel)
        labelsStackView.addArrangedSubview(welcomeImageLabel)
        
        progressView.progressViewStyle = .default
        progressView.trackTintColor = .white.withAlphaComponent(0.2)
        progressView.progressTintColor = .white
        progressView.setProgress(0, animated: true)
    }
    
    func setupLayout() {
        addSubview(backgroundImageView, constraints: [
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundImageView.addSubview(heartsImageView, constraints: [
            heartsImageView.topAnchor.constraint(equalTo: backgroundImageView.safeAreaLayoutGuide.topAnchor),
            heartsImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            heartsImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            heartsImageView.bottomAnchor.constraint(equalTo: backgroundImageView.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        heartsImageView.addSubview(labelsContainer, constraints: [
            labelsContainer.topAnchor.constraint(equalTo: heartsImageView.topAnchor),
            labelsContainer.leadingAnchor.constraint(equalTo: heartsImageView.leadingAnchor),
            labelsContainer.trailingAnchor.constraint(equalTo: heartsImageView.trailingAnchor),
            labelsContainer.heightAnchor.constraint(
                equalTo: heartsImageView.heightAnchor,
                multiplier: Constants.labelsContainerHeightMultiplier
            )
        ])
        
        labelsContainer.addSubview(labelsStackView, constraints: [
            labelsStackView.leadingAnchor.constraint(
                equalTo: labelsContainer.leadingAnchor,
                constant: Constants.labelsStackViewPadding
            ),
            labelsStackView.trailingAnchor.constraint(
                equalTo: labelsContainer.trailingAnchor,
                constant: -Constants.labelsStackViewPadding
            ),
            labelsStackView.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor)
        ])
        
        heartsImageView.addSubview(progressView, constraints: [
            progressView.topAnchor.constraint(
                equalTo: labelsStackView.bottomAnchor,
                constant: Constants.progressViewTopPedding
            ),
            progressView.leadingAnchor.constraint(
                equalTo: heartsImageView.leadingAnchor,
                constant: Constants.progressViewSidePedding
            ),
            progressView.trailingAnchor.constraint(
                equalTo: heartsImageView.trailingAnchor,
                constant: -Constants.progressViewSidePedding
            ),
            progressView.heightAnchor.constraint(equalToConstant: Constants.progressViewHeight)
        ])
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let labelsContainerHeightMultiplier: CGFloat = 0.4
    static let labelsStackViewSpacing: CGFloat = 12
    static let progerssTime = 2.0
    static let labelsStackViewPadding: CGFloat = 62
    static let progressViewTopPedding: CGFloat = 19
    static let progressViewSidePedding: CGFloat = 50
    static let progressViewHeight: CGFloat = 6
}

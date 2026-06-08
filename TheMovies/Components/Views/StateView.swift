//
//  StateView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class StateView: UIView {

    enum State {
        case loading
        case empty(title: String, message: String?, systemImage: String)
        case error(AppError)
    }

    var onRetry: (() -> Void)?

    private let stackView = UIStackView.vertical(spacing: LayoutSpacing.medium, alignment: .center)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with state: State) {
        subviews.forEach { $0.removeFromSuperview() }
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }

        addSubview(stackView)
        stackView.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.large, bottom: 0, right: LayoutSpacing.large
        ))
        stackView.centerYInSuperview()

        switch state {
        case .loading:
            activityIndicator.startAnimating()
            stackView.addArrangedSubviews(activityIndicator)

        case .empty(let title, let message, let systemImage):
            configureImage(systemImage)
            configureTitle(title)
            if let message {
                configureMessage(message)
            }

        case .error(let error):
            configureImage("exclamationmark.triangle")
            configureTitle("Something went wrong")
            configureMessage(error.errorDescription ?? "Unknown error")
            if error.recoverySuggestion != nil {
                configureRetryButton()
            }
        }
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        stackView.useAutoLayout()

        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        imageView.useAutoLayout()
        imageView.setSize(width: 48, height: 48)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = .preferredFont(forTextStyle: .subheadline)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    private func configureImage(_ systemName: String) {
        imageView.image = UIImage(systemName: systemName)
        stackView.addArrangedSubview(imageView)
    }

    private func configureTitle(_ text: String) {
        titleLabel.text = text
        stackView.addArrangedSubview(titleLabel)
    }

    private func configureMessage(_ text: String) {
        messageLabel.text = text
        stackView.addArrangedSubview(messageLabel)
    }

    private func configureRetryButton() {
        stackView.addArrangedSubview(retryButton)
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}

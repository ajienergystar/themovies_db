//
//  YouTubePlayerView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit
import WebKit

final class YouTubePlayerView: UIView {

    private let webView = WKWebView()
    private let emptyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadVideo(key: String) {
        guard let url = URL(string: TMDBConstants.youtubeEmbedBaseURL + key) else { return }
        emptyLabel.isHidden = true
        webView.isHidden = false
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func showEmptyState() {
        webView.isHidden = true
        emptyLabel.isHidden = false
    }

    private func setupUI() {
        layer.cornerRadius = AppTheme.cornerRadius
        clipsToBounds = true

        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black

        emptyLabel.text = "No trailer available"
        emptyLabel.font = .preferredFont(forTextStyle: .subheadline)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.textAlignment = .center

        addSubviews(webView, emptyLabel)
        webView.useAutoLayout()
        emptyLabel.useAutoLayout()

        webView.pinToSuperview()
        emptyLabel.centerInSuperview()
        emptyLabel.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: LayoutSpacing.medium
        ))

        showEmptyState()
    }
}

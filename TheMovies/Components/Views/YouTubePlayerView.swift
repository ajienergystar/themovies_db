//
//  YouTubePlayerView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit
import WebKit

final class YouTubePlayerView: UIView {

    private let webView: WKWebView
    private let emptyLabel = UILabel()

    override init(frame: CGRect) {
        webView = WKWebView(frame: .zero, configuration: Self.makeConfiguration())
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        webView = WKWebView(frame: .zero, configuration: Self.makeConfiguration())
        super.init(coder: coder)
        setupUI()
    }

    func loadVideo(key: String) {
        emptyLabel.isHidden = true
        webView.isHidden = false

        let origin = Self.embedOrigin
        let embedURL = Self.embedURL(for: key, origin: origin)
        let html = Self.embedHTML(embedURL: embedURL)
        webView.loadHTMLString(html, baseURL: origin)
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

    private static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        return configuration
    }

    private static var embedOrigin: URL {
        let bundleID = Bundle.main.bundleIdentifier ?? "localhost"
        return URL(string: "https://\(bundleID)")!
    }

    private static func embedURL(for key: String, origin: URL) -> String {
        var components = URLComponents(string: TMDBConstants.youtubeEmbedBaseURL + key)!
        components.queryItems = [
            URLQueryItem(name: "playsinline", value: "1"),
            URLQueryItem(name: "rel", value: "0"),
            URLQueryItem(name: "modestbranding", value: "1"),
            URLQueryItem(name: "origin", value: origin.absoluteString)
        ]
        return components.url!.absoluteString
    }

    private static func embedHTML(embedURL: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <meta name="referrer" content="strict-origin-when-cross-origin">
            <style>
                * { margin: 0; padding: 0; }
                html, body { width: 100%; height: 100%; background: #000; overflow: hidden; }
                iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
            </style>
        </head>
        <body>
            <iframe
                src="\(embedURL)"
                referrerpolicy="strict-origin-when-cross-origin"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """
    }
}

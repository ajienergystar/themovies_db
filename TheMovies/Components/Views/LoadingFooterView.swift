//
//  LoadingFooterView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class LoadingFooterView: UICollectionReusableView {

    static let reuseIdentifier = "LoadingFooterView"

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }

    private func setupUI() {
        addSubview(activityIndicator)
        activityIndicator.useAutoLayout()
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
    }
}

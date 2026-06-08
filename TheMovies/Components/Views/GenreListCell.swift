//
//  GenreListCell.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class GenreListCell: UITableViewCell {

    static let reuseIdentifier = "GenreListCell"

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String) {
        titleLabel.text = name
    }

    private func setupUI() {
        accessoryType = .none
        selectionStyle = .default

        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label

        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.useAutoLayout()
        chevronImageView.setSize(width: 12, height: 16)

        contentView.addSubviews(titleLabel, chevronImageView)

        titleLabel.useAutoLayout()
        titleLabel.pinToSuperview(edges: [.top, .bottom, .left], padding: UIEdgeInsets(
            top: LayoutSpacing.medium,
            left: LayoutSpacing.medium,
            bottom: LayoutSpacing.medium,
            right: 0
        ))
        titleLabel.pinToTrailing(of: chevronImageView, spacing: LayoutSpacing.small)

        chevronImageView.pinToSuperview(edges: [.right], padding: UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: LayoutSpacing.medium
        ))
        chevronImageView.centerYInSuperview()
    }
}

//
//  ReviewCardView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class ReviewCardView: UIView {

    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let headerStack = UIStackView.horizontal(spacing: LayoutSpacing.small, alignment: .center, distribution: .fill)
    private let mainStack = UIStackView.vertical(spacing: LayoutSpacing.small)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with review: Review) {
        authorLabel.text = review.author
        dateLabel.text = review.formattedDate
        contentLabel.text = review.content
    }

    private func setupUI() {
        backgroundColor = AppTheme.secondaryBackground
        layer.cornerRadius = AppTheme.cornerRadius

        authorLabel.font = .preferredFont(forTextStyle: .headline)
        authorLabel.textColor = .label
        authorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .right
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        contentLabel.font = .preferredFont(forTextStyle: .body)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0

        headerStack.addArrangedSubviews(authorLabel, dateLabel)
        mainStack.addArrangedSubviews(headerStack, contentLabel)

        addSubview(mainStack)
        mainStack.useAutoLayout()
        mainStack.pinToSuperview(edges: .all, padding: UIEdgeInsets(
            top: LayoutSpacing.medium,
            left: LayoutSpacing.medium,
            bottom: LayoutSpacing.medium,
            right: LayoutSpacing.medium
        ))
    }
}

//
//  MoviePosterCell.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit
import Kingfisher

final class MoviePosterCell: UICollectionViewCell {

    static let reuseIdentifier = "MoviePosterCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingStack = UIStackView.horizontal(spacing: LayoutSpacing.extraSmall, alignment: .center)
    private let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let infoStack = UIStackView.vertical(spacing: AppTheme.cardInnerSpacing)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        releaseDateLabel.text = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = movie.ratingText
        releaseDateLabel.text = movie.releaseYear

        if let url = movie.posterURL {
            posterImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "film"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.tintColor = .tertiaryLabel
        }
    }

    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = AppTheme.cornerRadius
        posterImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1

        starImageView.tintColor = AppTheme.starColor
        starImageView.contentMode = .scaleAspectFit
        starImageView.useAutoLayout()
        starImageView.setSize(width: 12, height: 12)

        ratingLabel.font = .preferredFont(forTextStyle: .caption1)
        ratingLabel.textColor = .label

        releaseDateLabel.font = .preferredFont(forTextStyle: .caption2)
        releaseDateLabel.textColor = .secondaryLabel

        ratingStack.addArrangedSubviews(starImageView, ratingLabel)

        infoStack.addArrangedSubviews(titleLabel, ratingStack, releaseDateLabel)

        contentView.addSubviews(posterImageView, infoStack)
        posterImageView.useAutoLayout()
        infoStack.useAutoLayout()

        posterImageView.pinToSuperview(edges: [.top, .left, .right])
        posterImageView.setAspectRatio(AppTheme.posterAspectRatio)

        infoStack.pinBelow(posterImageView, spacing: LayoutSpacing.small)
        infoStack.pinToSuperview(edges: [.left, .right, .bottom])
    }
}

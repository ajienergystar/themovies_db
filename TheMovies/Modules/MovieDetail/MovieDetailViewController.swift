//
//  MovieDetailViewController.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit
import Kingfisher

final class MovieDetailViewController: UIViewController {

    var presenter: MovieDetailPresenterProtocol?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stateView = StateView()

    private let backdropImageView = UIImageView()
    private let gradientView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let metaLabel = UILabel()
    private let genreLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: MovieDetailTab.allCases.map(\.title))

    private let tabContainer = UIView()
    private let aboutStack = UIStackView.vertical(spacing: LayoutSpacing.medium)
    private let reviewsStack = UIStackView.vertical(spacing: LayoutSpacing.medium)
    private let reviewsFooter = UIActivityIndicatorView(style: .medium)
    private let youtubePlayerView = YouTubePlayerView()

    private var currentTab: MovieDetailTab = .about
    private var reviewCardViews: [ReviewCardView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = AppTheme.groupedBackground
        navigationItem.largeTitleDisplayMode = .never

        scrollView.useAutoLayout()
        scrollView.showsVerticalScrollIndicator = true
        contentView.useAutoLayout()

        stateView.useAutoLayout()
        stateView.onRetry = { [weak self] in
            self?.presenter?.retryTapped()
        }

        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

        gradientView.backgroundColor = .clear

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = AppTheme.cornerRadius
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.3
        posterImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        posterImageView.layer.shadowRadius = 6
        posterImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        metaLabel.font = .preferredFont(forTextStyle: .subheadline)
        metaLabel.textColor = .secondaryLabel

        genreLabel.font = .preferredFont(forTextStyle: .footnote)
        genreLabel.textColor = .secondaryLabel
        genreLabel.numberOfLines = 0

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)

        tabContainer.backgroundColor = .clear
        aboutStack.isHidden = false
        reviewsStack.isHidden = true
        youtubePlayerView.isHidden = true

        reviewsFooter.hidesWhenStopped = true

        view.addSubviews(scrollView, stateView)
        scrollView.delegate = self

        scrollView.pinToSuperviewSafeArea()
        stateView.pinToSuperviewSafeArea()

        LayoutHelper.embed(contentView, in: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        contentView.addSubviews(
            backdropImageView,
            gradientView,
            posterImageView,
            titleLabel,
            metaLabel,
            genreLabel,
            segmentedControl,
            tabContainer
        )

        backdropImageView.useAutoLayout()
        gradientView.useAutoLayout()
        posterImageView.useAutoLayout()
        titleLabel.useAutoLayout()
        metaLabel.useAutoLayout()
        genreLabel.useAutoLayout()
        segmentedControl.useAutoLayout()
        tabContainer.useAutoLayout()

        backdropImageView.pinToSuperview(edges: [.top, .left, .right])
        backdropImageView.setSize(height: AppTheme.backdropHeight)

        gradientView.pin(to: backdropImageView)
        addGradient(to: gradientView)

        posterImageView.setSize(width: AppTheme.detailPosterWidth)
        posterImageView.setAspectRatio(AppTheme.posterAspectRatio)
        posterImageView.pinToSuperview(edges: [.left], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: 0
        ))
        posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -20).isActive = true

        titleLabel.pinBelow(backdropImageView, spacing: LayoutSpacing.large)
        titleLabel.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: LayoutSpacing.medium
        ))

        metaLabel.pinBelow(titleLabel, spacing: LayoutSpacing.extraSmall)
        metaLabel.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: LayoutSpacing.medium
        ))

        genreLabel.pinBelow(metaLabel, spacing: LayoutSpacing.extraSmall)
        genreLabel.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: LayoutSpacing.medium
        ))

        segmentedControl.pinBelow(genreLabel, spacing: LayoutSpacing.medium)
        segmentedControl.pinToSuperview(edges: [.left, .right], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: 0, right: LayoutSpacing.medium
        ))

        tabContainer.pinBelow(segmentedControl, spacing: LayoutSpacing.medium)
        tabContainer.pinToSuperview(edges: [.left, .right, .bottom], padding: UIEdgeInsets(
            top: 0, left: LayoutSpacing.medium, bottom: LayoutSpacing.large, right: LayoutSpacing.medium
        ))

        tabContainer.addSubviews(aboutStack, reviewsStack, youtubePlayerView)
        aboutStack.useAutoLayout()
        reviewsStack.useAutoLayout()
        youtubePlayerView.useAutoLayout()

        aboutStack.pinToSuperview()
        reviewsStack.pinToSuperview()
        youtubePlayerView.pinToSuperview()
        youtubePlayerView.setAspectRatio(AppTheme.backdropAspectRatio)

        stateView.isHidden = true
    }

    private func addGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: AppTheme.backdropHeight)
        view.layer.addSublayer(gradient)
    }

    @objc private func tabChanged() {
        guard let tab = MovieDetailTab(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        currentTab = tab
        aboutStack.isHidden = tab != .about
        reviewsStack.isHidden = tab != .reviews
        youtubePlayerView.isHidden = tab != .trailer
        presenter?.didSelectTab(tab)
    }

    private func buildAboutContent(for detail: MovieDetail) {
        aboutStack.removeAllArrangedSubviews()

        let synopsisTitle = makeSectionTitle("Synopsis")
        let synopsisBody = makeBodyLabel(detail.overview ?? "No overview available.")
        aboutStack.addArrangedSubviews(synopsisTitle, synopsisBody)

        if !detail.genres.isEmpty {
            let genreTitle = makeSectionTitle("Genres")
            let chipScroll = UIScrollView()
            chipScroll.showsHorizontalScrollIndicator = false
            chipScroll.useAutoLayout()
            chipScroll.heightAnchor.constraint(equalToConstant: 32).isActive = true

            let chipStack = UIStackView.horizontal(spacing: LayoutSpacing.small)
            chipStack.useAutoLayout()
            chipScroll.addSubview(chipStack)
            chipStack.pinToSuperview(edges: [.top, .bottom, .left, .right])
            chipStack.heightAnchor.constraint(equalTo: chipScroll.heightAnchor).isActive = true

            detail.genres.forEach { genre in
                chipStack.addArrangedSubview(GenreChipView(name: genre.name))
            }

            aboutStack.addArrangedSubviews(genreTitle, chipScroll)
        }

        let infoTitle = makeSectionTitle("Information")
        let infoStack = UIStackView.vertical(spacing: LayoutSpacing.small)
        infoStack.addArrangedSubviews(
            makeInfoRow(title: "Release Date", value: detail.releaseDate ?? "N/A"),
            makeInfoRow(title: "Duration", value: detail.runtimeText),
            makeInfoRow(title: "Rating", value: detail.ratingText)
        )
        aboutStack.addArrangedSubviews(infoTitle, infoStack)
    }

    private func makeSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .headline).withWeight(.semibold)
        label.textColor = .label
        return label
    }

    private func makeBodyLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }

    private func makeInfoRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .preferredFont(forTextStyle: .subheadline)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right

        let stack = UIStackView.horizontal(distribution: .fillEqually)
        stack.addArrangedSubviews(titleLabel, valueLabel)
        return stack
    }

    private func rebuildReviews(_ reviews: [Review]) {
        reviewsStack.removeAllArrangedSubviews()
        reviewCardViews.removeAll()

        if reviews.isEmpty {
            let emptyLabel = makeBodyLabel("No reviews yet.")
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .secondaryLabel
            reviewsStack.addArrangedSubview(emptyLabel)
        } else {
            reviews.forEach { review in
                let card = ReviewCardView()
                card.configure(with: review)
                reviewCardViews.append(card)
                reviewsStack.addArrangedSubview(card)
            }
        }

        reviewsStack.addArrangedSubview(reviewsFooter)
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func showLoading() {
        stateView.isHidden = false
        scrollView.isHidden = true
        stateView.configure(with: .loading)
    }

    func hideLoading() {
        stateView.isHidden = true
        scrollView.isHidden = false
    }

    func showDetail(_ detail: MovieDetail) {
        title = detail.title
        titleLabel.text = detail.title
        metaLabel.text = "★ \(detail.ratingText)  •  \(detail.runtimeText)"
        genreLabel.text = detail.genreNames

        if let url = detail.backdropURL {
            backdropImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
        if let url = detail.posterURL {
            posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }

        buildAboutContent(for: detail)
    }

    func showReviews(_ reviews: [Review]) {
        rebuildReviews(reviews)
    }

    func appendReviews(_ reviews: [Review]) {
        reviews.forEach { review in
            let card = ReviewCardView()
            card.configure(with: review)
            reviewCardViews.append(card)
            reviewsStack.insertArrangedSubview(card, at: reviewsStack.arrangedSubviews.count - 1)
        }
        presenter?.loadMoreReviewsIfNeeded(currentIndex: reviewCardViews.count - 1)
    }

    func showTrailer(key: String?) {
        if let key {
            youtubePlayerView.loadVideo(key: key)
        } else {
            youtubePlayerView.showEmptyState()
        }
    }

    func showError(_ error: AppError) {
        stateView.isHidden = false
        scrollView.isHidden = true
        stateView.configure(with: .error(error))
    }

    func showReviewsFooterLoading(_ isLoading: Bool) {
        isLoading ? reviewsFooter.startAnimating() : reviewsFooter.stopAnimating()
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard currentTab == .reviews, !reviewCardViews.isEmpty else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height

        if offsetY > contentHeight - frameHeight - 120 {
            presenter?.loadMoreReviewsIfNeeded(currentIndex: reviewCardViews.count - 1)
        }
    }
}

private extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

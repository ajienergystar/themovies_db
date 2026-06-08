//
//  MovieDetailPresenter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class MovieDetailPresenter: MovieDetailPresenterProtocol {

    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorInputProtocol?

    private let movieID: Int
    private var detail: MovieDetail?
    private var reviews: [Review] = []
    private var reviewsPage = 1
    private var hasMoreReviews = true
    private var isLoadingReviews = false
    private var trailerKey: String?
    private var selectedTab: MovieDetailTab = .about

    init(movieID: Int) {
        self.movieID = movieID
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchMovieDetail(id: movieID)
        interactor?.fetchVideos(movieID: movieID)
    }

    func didSelectTab(_ tab: MovieDetailTab) {
        selectedTab = tab
        if tab == .reviews, reviews.isEmpty, !isLoadingReviews {
            loadReviews(page: 1)
        }
    }

    func loadMoreReviewsIfNeeded(currentIndex: Int) {
        guard selectedTab == .reviews, !isLoadingReviews, hasMoreReviews else { return }
        let thresholdIndex = reviews.count - 2
        guard currentIndex >= thresholdIndex else { return }
        loadReviews(page: reviewsPage + 1)
    }

    func retryTapped() {
        view?.showLoading()
        interactor?.fetchMovieDetail(id: movieID)
        interactor?.fetchVideos(movieID: movieID)
        if selectedTab == .reviews {
            reviews = []
            reviewsPage = 1
            hasMoreReviews = true
            loadReviews(page: 1)
        }
    }

    private func loadReviews(page: Int) {
        isLoadingReviews = true
        if page > 1 {
            view?.showReviewsFooterLoading(true)
        }
        interactor?.fetchReviews(movieID: movieID, page: page)
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {
    func didFetchMovieDetail(_ detail: MovieDetail) {
        self.detail = detail
        view?.hideLoading()
        view?.showDetail(detail)
        loadReviews(page: 1)
    }

    func didFetchReviews(_ reviews: [Review], page: Int, hasMore: Bool) {
        isLoadingReviews = false
        reviewsPage = page
        hasMoreReviews = hasMore
        view?.showReviewsFooterLoading(false)

        if page == 1 {
            self.reviews = reviews
            view?.showReviews(reviews)
        } else {
            self.reviews.append(contentsOf: reviews)
            view?.appendReviews(reviews)
        }
    }

    func didFetchTrailer(key: String?) {
        trailerKey = key
        view?.showTrailer(key: key)
    }

    func didFailWithError(_ error: AppError, context: MovieDetailErrorContext) {
        switch context {
        case .detail:
            view?.hideLoading()
            view?.showError(error)
        case .reviews(let page):
            isLoadingReviews = false
            view?.showReviewsFooterLoading(false)
            if page == 1, reviews.isEmpty {
                view?.showReviews([])
            }
        case .videos:
            view?.showTrailer(key: nil)
        }
    }
}

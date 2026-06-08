//
//  MovieDetailMocks.swift
//  TheMoviesTests
//

import UIKit
@testable import TheMovies

@MainActor
final class MovieDetailViewSpy: MovieDetailViewProtocol {

    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var displayedDetail: MovieDetail?
    private(set) var displayedReviews: [Review]?
    private(set) var appendedReviews: [[Review]] = []
    private(set) var showTrailerCallCount = 0
    private(set) var displayedTrailerKey: String?
    private(set) var displayedError: AppError?
    private(set) var reviewsFooterLoadingStates: [Bool] = []

    func showLoading() {
        showLoadingCallCount += 1
    }

    func hideLoading() {
        hideLoadingCallCount += 1
    }

    func showDetail(_ detail: MovieDetail) {
        displayedDetail = detail
    }

    func showReviews(_ reviews: [Review]) {
        displayedReviews = reviews
    }

    func appendReviews(_ reviews: [Review]) {
        appendedReviews.append(reviews)
    }

    func showTrailer(key: String?) {
        showTrailerCallCount += 1
        displayedTrailerKey = key
    }

    func showError(_ error: AppError) {
        displayedError = error
    }

    func showReviewsFooterLoading(_ isLoading: Bool) {
        reviewsFooterLoadingStates.append(isLoading)
    }
}

final class MovieDetailInteractorOutputSpy: MovieDetailInteractorOutputProtocol {

    private(set) var fetchedDetail: MovieDetail?
    private(set) var fetchedReviews: [Review]?
    private(set) var fetchedReviewsPage: Int?
    private(set) var fetchedReviewsHasMore: Bool?
    private(set) var didFetchTrailerCalled = false
    private(set) var fetchedTrailerKey: String?
    private(set) var fetchError: AppError?
    private(set) var errorContext: MovieDetailErrorContext?

    func didFetchMovieDetail(_ detail: MovieDetail) {
        fetchedDetail = detail
    }

    func didFetchReviews(_ reviews: [Review], page: Int, hasMore: Bool) {
        fetchedReviews = reviews
        fetchedReviewsPage = page
        fetchedReviewsHasMore = hasMore
    }

    func didFetchTrailer(key: String?) {
        didFetchTrailerCalled = true
        fetchedTrailerKey = key
    }

    func didFailWithError(_ error: AppError, context: MovieDetailErrorContext) {
        fetchError = error
        errorContext = context
    }
}

final class MovieDetailInteractorInputSpy: MovieDetailInteractorInputProtocol {

    private(set) var fetchDetailRequests: [Int] = []
    private(set) var fetchReviewRequests: [(movieID: Int, page: Int)] = []
    private(set) var fetchVideoRequests: [Int] = []

    func fetchMovieDetail(id: Int) {
        fetchDetailRequests.append(id)
    }

    func fetchReviews(movieID: Int, page: Int) {
        fetchReviewRequests.append((movieID, page))
    }

    func fetchVideos(movieID: Int) {
        fetchVideoRequests.append(movieID)
    }
}

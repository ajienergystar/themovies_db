//
//  MovieDetailPresenterTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Testing
@testable import TheMovies

@Suite("MovieDetailPresenter")
@MainActor
struct MovieDetailPresenterTests {

    private func makePresenter(
        movieID: Int = 550
    ) -> (MovieDetailPresenter, MovieDetailViewSpy, MovieDetailInteractorInputSpy) {
        let view = MovieDetailViewSpy()
        let interactor = MovieDetailInteractorInputSpy()
        let presenter = MovieDetailPresenter(movieID: movieID)
        presenter.view = view
        presenter.interactor = interactor
        return (presenter, view, interactor)
    }

    @Test("viewDidLoad fetches detail and videos")
    func viewDidLoad() {
        let (presenter, view, interactor) = makePresenter()

        presenter.viewDidLoad()

        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchDetailRequests == [550])
        #expect(interactor.fetchVideoRequests == [550])
    }

    @Test("didFetchMovieDetail shows detail and loads reviews")
    func didFetchMovieDetail() throws {
        let (presenter, view, interactor) = makePresenter()
        let detail = try TestFixtures.sampleMovieDetail

        presenter.didFetchMovieDetail(detail)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedDetail?.id == detail.id)
        #expect(interactor.fetchReviewRequests.count == 1)
        #expect(interactor.fetchReviewRequests.first?.movieID == 550)
        #expect(interactor.fetchReviewRequests.first?.page == 1)
    }

    @Test("didFetchReviews on first page shows reviews")
    func didFetchReviewsFirstPage() throws {
        let (presenter, view, _) = makePresenter()
        let reviews = try TestFixtures.reviewListResponse.results

        presenter.didFetchReviews(reviews, page: 1, hasMore: true)

        #expect(view.displayedReviews?.count == reviews.count)
        #expect(view.reviewsFooterLoadingStates == [false])
    }

    @Test("didFetchReviews on next page appends reviews")
    func didFetchReviewsNextPage() throws {
        let (presenter, view, _) = makePresenter()
        let reviews = try TestFixtures.reviewListResponse.results

        presenter.didFetchReviews(reviews, page: 1, hasMore: true)
        presenter.didFetchReviews(reviews, page: 2, hasMore: false)

        #expect(view.appendedReviews.count == 1)
    }

    @Test("didFetchTrailer updates view with trailer key")
    func didFetchTrailer() {
        let (presenter, view, _) = makePresenter()

        presenter.didFetchTrailer(key: "abc123")

        #expect(view.displayedTrailerKey == "abc123")
    }

    @Test("didSelectTab loads reviews when reviews tab selected and list is empty")
    func didSelectReviewsTab() {
        let (presenter, _, interactor) = makePresenter()

        presenter.didSelectTab(.reviews)

        #expect(interactor.fetchReviewRequests.count == 1)
        #expect(interactor.fetchReviewRequests.first?.movieID == 550)
        #expect(interactor.fetchReviewRequests.first?.page == 1)
    }

    @Test("didSelectTab does not reload reviews when already loaded")
    func didSelectReviewsTabCached() throws {
        let (presenter, _, interactor) = makePresenter()
        presenter.didFetchReviews(try TestFixtures.reviewListResponse.results, page: 1, hasMore: false)

        presenter.didSelectTab(.reviews)

        #expect(interactor.fetchReviewRequests.isEmpty)
    }

    @Test("loadMoreReviewsIfNeeded fetches next page near end of list")
    func loadMoreReviewsIfNeeded() throws {
        let (presenter, view, interactor) = makePresenter()
        let reviews = try TestFixtures.reviewListResponse.results
        presenter.didFetchReviews(reviews, page: 1, hasMore: true)
        presenter.didSelectTab(.reviews)

        presenter.loadMoreReviewsIfNeeded(currentIndex: reviews.count - 2)

        #expect(interactor.fetchReviewRequests.contains { $0.page == 2 })
        #expect(view.reviewsFooterLoadingStates.contains(true))
    }

    @Test("didFailWithError on detail shows error")
    func didFailDetail() {
        let (presenter, view, _) = makePresenter()

        presenter.didFailWithError(.networkUnavailable, context: .detail)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedError == .networkUnavailable)
    }

    @Test("didFailWithError on reviews page 1 shows empty reviews")
    func didFailReviewsFirstPage() {
        let (presenter, view, _) = makePresenter()

        presenter.didFailWithError(.serverError(statusCode: 500), context: .reviews(page: 1))

        #expect(view.displayedReviews == [])
        #expect(view.reviewsFooterLoadingStates == [false])
    }

    @Test("didFailWithError on videos hides trailer")
    func didFailVideos() {
        let (presenter, view, _) = makePresenter()

        presenter.didFailWithError(.networkUnavailable, context: .videos)

        #expect(view.showTrailerCallCount == 1)
        #expect(view.displayedTrailerKey == nil)
    }

    @Test("retryTapped reloads detail, videos, and reviews when on reviews tab")
    func retryTappedOnReviewsTab() throws {
        let (presenter, view, interactor) = makePresenter()
        presenter.didSelectTab(.reviews)
        presenter.didFetchReviews(try TestFixtures.reviewListResponse.results, page: 1, hasMore: true)

        presenter.retryTapped()

        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchDetailRequests == [550])
        #expect(interactor.fetchVideoRequests == [550])
        #expect(interactor.fetchReviewRequests.contains { $0.page == 1 })
    }
}

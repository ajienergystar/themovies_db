//
//  MovieDetailInteractorTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Testing
@testable import TheMovies

@Suite("MovieDetailInteractor")
struct MovieDetailInteractorTests {

    @Test("fetchMovieDetail delivers detail on success")
    func fetchMovieDetailSuccess() async throws {
        let apiClient = MockAPIClient()
        let detail = try TestFixtures.sampleMovieDetail
        apiClient.movieDetailResult = .success(detail)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchMovieDetail(id: 550)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchedDetail != nil }
        #expect(didComplete)
        #expect(output.fetchedDetail?.id == 550)
    }

    @Test("fetchMovieDetail delivers error on failure")
    func fetchMovieDetailFailure() async {
        let apiClient = MockAPIClient()
        apiClient.movieDetailResult = .failure(AppError.invalidResponse)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchMovieDetail(id: 1)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchError != nil }
        #expect(didComplete)
        #expect(output.fetchError == .invalidResponse)
        if case .detail = output.errorContext {
            #expect(Bool(true))
        } else {
            Issue.record("Expected detail error context")
        }
    }

    @Test("fetchReviews delivers reviews and pagination metadata")
    func fetchReviewsSuccess() async throws {
        let apiClient = MockAPIClient()
        apiClient.reviewListResult = .success(try TestFixtures.reviewListResponse)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchReviews(movieID: 550, page: 1)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchedReviews != nil }
        #expect(didComplete)
        #expect(output.fetchedReviewsPage == 1)
        #expect(output.fetchedReviewsHasMore == true)
    }

    @Test("fetchReviews delivers error with page context")
    func fetchReviewsFailure() async {
        let apiClient = MockAPIClient()
        apiClient.reviewListResult = .failure(AppError.serverError(statusCode: 500))

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchReviews(movieID: 550, page: 2)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchError != nil }
        #expect(didComplete)

        if case .reviews(let page) = output.errorContext {
            #expect(page == 2)
        } else {
            Issue.record("Expected reviews error context")
        }
    }

    @Test("fetchVideos delivers first YouTube trailer key")
    func fetchVideosSuccess() async throws {
        let apiClient = MockAPIClient()
        apiClient.videoListResult = .success(try TestFixtures.videoListResponse)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchVideos(movieID: 550)

        let didComplete = await AsyncTestHelpers.waitUntil { output.didFetchTrailerCalled }
        #expect(didComplete)
        #expect(output.fetchedTrailerKey == "dQw4w9WgXcQ")
    }

    @Test("fetchVideos delivers nil when no trailer exists")
    func fetchVideosNoTrailer() async throws {
        let apiClient = MockAPIClient()
        let json = """
        {
            "results": [
                {
                    "id": "v1",
                    "key": "key",
                    "name": "Clip",
                    "site": "YouTube",
                    "type": "Clip"
                }
            ]
        }
        """
        let response = try TestFixtures.decode(VideoListResponse.self, from: json)
        apiClient.videoListResult = .success(response)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchVideos(movieID: 550)

        let didComplete = await AsyncTestHelpers.waitUntil { output.didFetchTrailerCalled }
        #expect(didComplete)
        #expect(output.fetchedTrailerKey == nil)
    }

    @Test("fetchVideos failure uses videos error context")
    func fetchVideosFailure() async {
        let apiClient = MockAPIClient()
        apiClient.videoListResult = .failure(AppError.networkUnavailable)

        let interactor = MovieDetailInteractor(apiClient: apiClient)
        let output = MovieDetailInteractorOutputSpy()
        interactor.output = output

        interactor.fetchVideos(movieID: 550)

        let didComplete = await AsyncTestHelpers.waitUntil { output.errorContext != nil }
        #expect(didComplete)
        if case .videos = output.errorContext {
            #expect(Bool(true))
        } else {
            Issue.record("Expected videos error context")
        }
    }
}

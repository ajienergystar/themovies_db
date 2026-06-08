//
//  MovieListInteractorTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("MovieListInteractor")
struct MovieListInteractorTests {

    @Test("fetchMovies delivers movies and hasMore flag")
    func fetchMoviesSuccess() async throws {
        let apiClient = MockAPIClient()
        let response = try TestFixtures.movieListResponse
        apiClient.discoverMoviesResult = .success(response)

        let interactor = MovieListInteractor(apiClient: apiClient)
        let output = MovieListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchMovies(genreID: 28, page: 1)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchedMovies != nil }
        #expect(didComplete)

        let movies = output.fetchedMovies
        #expect(movies?.count == 2)
        #expect(output.fetchedPage == 1)
        #expect(output.fetchedHasMore == true)
        #expect(apiClient.requestedEndpoints.count == 1)
        if case .discoverMovies(let genreID, let page) = apiClient.requestedEndpoints.first {
            #expect(genreID == 28)
            #expect(page == 1)
        } else {
            Issue.record("Expected discoverMovies endpoint")
        }
    }

    @Test("fetchMovies sets hasMore to false on last page")
    func fetchMoviesLastPage() async throws {
        let apiClient = MockAPIClient()
        var response = try TestFixtures.movieListResponse
        let lastPageJSON = TestFixtures.movieListJSON.replacingOccurrences(of: "\"page\": 1", with: "\"page\": 3")
        response = try TestFixtures.decode(MovieListResponse.self, from: lastPageJSON)
        apiClient.discoverMoviesResult = .success(response)

        let interactor = MovieListInteractor(apiClient: apiClient)
        let output = MovieListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchMovies(genreID: 28, page: 3)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchedHasMore != nil }
        #expect(didComplete)
        #expect(output.fetchedHasMore == false)
    }

    @Test("fetchMovies delivers error with page context")
    func fetchMoviesFailure() async {
        let apiClient = MockAPIClient()
        apiClient.discoverMoviesResult = .failure(AppError.emptyData)

        let interactor = MovieListInteractor(apiClient: apiClient)
        let output = MovieListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchMovies(genreID: 12, page: 2)

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchError != nil }
        #expect(didComplete)

        #expect(output.fetchError == .emptyData)
        #expect(output.failedPage == 2)
    }
}

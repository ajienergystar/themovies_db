//
//  GenreListInteractorTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("GenreListInteractor")
struct GenreListInteractorTests {

    @Test("fetchGenres delivers sorted genres on success")
    func fetchGenresSuccess() async throws {
        let apiClient = MockAPIClient()
        let response = try TestFixtures.decode(GenreListResponse.self, from: TestFixtures.genreListJSON)
        apiClient.genreListResult = .success(response)

        let interactor = GenreListInteractor(apiClient: apiClient)
        let output = GenreListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchGenres()

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchedGenres != nil }
        #expect(didComplete)

        let genres = output.fetchedGenres
        #expect(genres?.map(\.name) == ["Action", "Adventure", "Comedy"])
        #expect(apiClient.requestCallCount == 1)
    }

    @Test("fetchGenres delivers AppError on API failure")
    func fetchGenresAppError() async {
        let apiClient = MockAPIClient()
        apiClient.genreListResult = .failure(AppError.serverError(statusCode: 500))

        let interactor = GenreListInteractor(apiClient: apiClient)
        let output = GenreListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchGenres()

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchError != nil }
        #expect(didComplete)

        #expect(output.fetchError == .serverError(statusCode: 500))
    }

    @Test("fetchGenres wraps unknown errors as custom AppError")
    func fetchGenresUnknownError() async {
        struct SampleError: Error {}
        let apiClient = MockAPIClient()
        apiClient.genreListResult = .failure(SampleError())

        let interactor = GenreListInteractor(apiClient: apiClient)
        let output = GenreListInteractorOutputSpy()
        interactor.output = output

        interactor.fetchGenres()

        let didComplete = await AsyncTestHelpers.waitUntil { output.fetchError != nil }
        #expect(didComplete)

        if case .custom = output.fetchError {
            #expect(Bool(true))
        } else {
            Issue.record("Expected custom AppError")
        }
    }
}

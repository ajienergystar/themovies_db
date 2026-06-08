//
//  GenreListPresenterTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("GenreListPresenter")
@MainActor
struct GenreListPresenterTests {

    @Test("viewDidLoad shows loading and fetches genres")
    func viewDidLoad() {
        let view = GenreListViewSpy()
        let interactor = GenreListInteractorInputSpy()
        let presenter = GenreListPresenter()
        presenter.view = view
        presenter.interactor = interactor

        presenter.viewDidLoad()

        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchGenresCallCount == 1)
    }

    @Test("didFetchGenres shows genres when data is available")
    func didFetchGenresWithData() async throws {
        let view = GenreListViewSpy()
        let presenter = GenreListPresenter()
        presenter.view = view
        let genres = try TestFixtures.genres

        presenter.didFetchGenres(genres)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedGenres?.count == genres.count)
        #expect(view.showEmptyCallCount == 0)
    }

    @Test("didFetchGenres shows empty state when no genres")
    func didFetchGenresEmpty() {
        let view = GenreListViewSpy()
        let presenter = GenreListPresenter()
        presenter.view = view

        presenter.didFetchGenres([])

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.showEmptyCallCount == 1)
        #expect(view.displayedGenres == nil)
    }

    @Test("didFailFetchingGenres shows error")
    func didFailFetchingGenres() {
        let view = GenreListViewSpy()
        let presenter = GenreListPresenter()
        presenter.view = view

        presenter.didFailFetchingGenres(.networkUnavailable)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedError == .networkUnavailable)
    }

    @Test("didSelectGenre navigates to movie list for valid index")
    func didSelectGenreValid() async throws {
        let view = GenreListViewSpy()
        let router = GenreListRouterSpy()
        let presenter = GenreListPresenter()
        presenter.view = view
        presenter.router = router
        let genres = try TestFixtures.genres

        presenter.didFetchGenres(genres)
        presenter.didSelectGenre(at: 1)

        #expect(router.navigatedGenre?.id == genres[1].id)
    }

    @Test("didSelectGenre ignores invalid index")
    func didSelectGenreInvalid() async throws {
        let router = GenreListRouterSpy()
        let presenter = GenreListPresenter()
        presenter.router = router
        presenter.didFetchGenres(try TestFixtures.genres)

        presenter.didSelectGenre(at: 99)

        #expect(router.navigatedGenre == nil)
    }

    @Test("retryTapped reloads genres")
    func retryTapped() {
        let view = GenreListViewSpy()
        let interactor = GenreListInteractorInputSpy()
        let presenter = GenreListPresenter()
        presenter.view = view
        presenter.interactor = interactor

        presenter.retryTapped()

        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchGenresCallCount == 1)
    }
}

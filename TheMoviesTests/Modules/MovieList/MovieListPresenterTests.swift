//
//  MovieListPresenterTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Testing
@testable import TheMovies

@Suite("MovieListPresenter")
@MainActor
struct MovieListPresenterTests {

    private func makePresenter(
        genre: Genre? = nil
    ) throws -> (MovieListPresenter, MovieListViewSpy, MovieListInteractorInputSpy, MovieListRouterSpy) {
        let genre = try genre ?? TestFixtures.sampleGenre
        let view = MovieListViewSpy()
        let interactor = MovieListInteractorInputSpy()
        let router = MovieListRouterSpy()
        let presenter = MovieListPresenter(genre: genre)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        return (presenter, view, interactor, router)
    }

    @Test("viewDidLoad sets title and fetches first page")
    func viewDidLoad() throws {
        let genre = try TestFixtures.sampleGenre
        let (presenter, view, interactor, _) = try makePresenter(genre: genre)

        presenter.viewDidLoad()

        #expect(view.title == genre.name)
        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchRequests.count == 1)
        #expect(interactor.fetchRequests.first?.genreID == genre.id)
        #expect(interactor.fetchRequests.first?.page == 1)
    }

    @Test("didFetchMovies on first page shows movies")
    func didFetchMoviesFirstPage() throws {
        let (presenter, view, _, _) = try makePresenter()
        let movies = try TestFixtures.movieListResponse.results

        presenter.didFetchMovies(movies, page: 1, hasMore: true)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedMovies?.count == movies.count)
        #expect(view.showEmptyCallCount == 0)
    }

    @Test("didFetchMovies on first page shows empty when no movies")
    func didFetchMoviesFirstPageEmpty() throws {
        let (presenter, view, _, _) = try makePresenter()

        presenter.didFetchMovies([], page: 1, hasMore: false)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.showEmptyCallCount == 1)
    }

    @Test("didFetchMovies on subsequent page appends movies")
    func didFetchMoviesNextPage() throws {
        let (presenter, view, _, _) = try makePresenter()
        let movies = try TestFixtures.movieListResponse.results

        presenter.didFetchMovies(movies, page: 1, hasMore: true)
        presenter.didFetchMovies(movies, page: 2, hasMore: false)

        #expect(view.appendedMovies.count == 1)
        #expect(view.footerLoadingStates == [false])
    }

    @Test("didFailFetchingMovies on first page shows error")
    func didFailFirstPage() throws {
        let (presenter, view, _, _) = try makePresenter()

        presenter.didFailFetchingMovies(.decodingFailed, page: 1)

        #expect(view.hideLoadingCallCount == 1)
        #expect(view.displayedError == .decodingFailed)
    }

    @Test("didSelectMovie navigates to detail for valid index")
    func didSelectMovieValid() throws {
        let (presenter, _, _, router) = try makePresenter()
        let movies = try TestFixtures.movieListResponse.results
        presenter.didFetchMovies(movies, page: 1, hasMore: false)

        presenter.didSelectMovie(at: 0)

        #expect(router.navigatedMovieID == movies[0].id)
    }

    @Test("didSelectMovie ignores invalid index")
    func didSelectMovieInvalid() throws {
        let (presenter, _, _, router) = try makePresenter()
        presenter.didFetchMovies(try TestFixtures.movieListResponse.results, page: 1, hasMore: false)

        presenter.didSelectMovie(at: 10)

        #expect(router.navigatedMovieID == nil)
    }

    @Test("loadNextPageIfNeeded fetches when near end of list")
    func loadNextPageIfNeeded() throws {
        let (presenter, view, interactor, _) = try makePresenter()
        let movies = try TestFixtures.movieListResponse.results
        presenter.didFetchMovies(movies, page: 1, hasMore: true)

        presenter.loadNextPageIfNeeded(currentIndex: movies.count - 4)

        #expect(interactor.fetchRequests.contains { $0.page == 2 })
        #expect(view.footerLoadingStates.contains(true))
    }

    @Test("loadNextPageIfNeeded does nothing when already loading or no more pages")
    func loadNextPageIfNeededSkipped() throws {
        let (presenter, _, interactor, _) = try makePresenter()
        let movies = try TestFixtures.movieListResponse.results
        presenter.viewDidLoad()
        presenter.didFetchMovies(movies, page: 1, hasMore: false)

        presenter.loadNextPageIfNeeded(currentIndex: movies.count - 1)

        #expect(interactor.fetchRequests.count == 1)
    }

    @Test("retryTapped reloads first page when list is empty")
    func retryTappedEmptyList() throws {
        let (presenter, view, interactor, _) = try makePresenter()
        presenter.didFailFetchingMovies(.networkUnavailable, page: 1)

        presenter.retryTapped()

        #expect(view.showLoadingCallCount == 1)
        #expect(interactor.fetchRequests.last?.page == 1)
    }

    @Test("retryTapped loads next page when list has data and more pages exist")
    func retryTappedWithPagination() throws {
        let (presenter, _, interactor, _) = try makePresenter()
        presenter.didFetchMovies(try TestFixtures.movieListResponse.results, page: 1, hasMore: true)

        presenter.retryTapped()

        #expect(interactor.fetchRequests.contains { $0.page == 2 })
    }
}

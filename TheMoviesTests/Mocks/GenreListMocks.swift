//
//  GenreListMocks.swift
//  TheMoviesTests
//

import UIKit
@testable import TheMovies

@MainActor
final class GenreListViewSpy: GenreListViewProtocol {

    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var displayedGenres: [Genre]?
    private(set) var showEmptyCallCount = 0
    private(set) var displayedError: AppError?

    func showLoading() {
        showLoadingCallCount += 1
    }

    func hideLoading() {
        hideLoadingCallCount += 1
    }

    func showGenres(_ genres: [Genre]) {
        displayedGenres = genres
    }

    func showEmpty() {
        showEmptyCallCount += 1
    }

    func showError(_ error: AppError) {
        displayedError = error
    }
}

@MainActor
final class GenreListRouterSpy: GenreListRouterProtocol {

    private(set) var navigatedGenre: Genre?

    static func createModule() -> UINavigationController {
        UINavigationController()
    }

    func navigateToMovieList(genre: Genre) {
        navigatedGenre = genre
    }
}

final class GenreListInteractorOutputSpy: GenreListInteractorOutputProtocol {

    private(set) var fetchedGenres: [Genre]?
    private(set) var fetchError: AppError?

    func didFetchGenres(_ genres: [Genre]) {
        fetchedGenres = genres
    }

    func didFailFetchingGenres(_ error: AppError) {
        fetchError = error
    }
}

final class GenreListInteractorInputSpy: GenreListInteractorInputProtocol {

    private(set) var fetchGenresCallCount = 0

    func fetchGenres() {
        fetchGenresCallCount += 1
    }
}

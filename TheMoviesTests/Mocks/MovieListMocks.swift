//
//  MovieListMocks.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit
@testable import TheMovies

@MainActor
final class MovieListViewSpy: MovieListViewProtocol {

    private(set) var title: String?
    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var displayedMovies: [Movie]?
    private(set) var appendedMovies: [[Movie]] = []
    private(set) var showEmptyCallCount = 0
    private(set) var displayedError: AppError?
    private(set) var footerLoadingStates: [Bool] = []

    func setTitle(_ title: String) {
        self.title = title
    }

    func showLoading() {
        showLoadingCallCount += 1
    }

    func hideLoading() {
        hideLoadingCallCount += 1
    }

    func showMovies(_ movies: [Movie]) {
        displayedMovies = movies
    }

    func appendMovies(_ movies: [Movie]) {
        appendedMovies.append(movies)
    }

    func showEmpty() {
        showEmptyCallCount += 1
    }

    func showError(_ error: AppError) {
        displayedError = error
    }

    func showFooterLoading(_ isLoading: Bool) {
        footerLoadingStates.append(isLoading)
    }
}

@MainActor
final class MovieListRouterSpy: MovieListRouterProtocol {

    private(set) var navigatedMovieID: Int?

    static func createModule(genre: Genre) -> UIViewController {
        UIViewController()
    }

    func navigateToMovieDetail(movieID: Int) {
        navigatedMovieID = movieID
    }
}

final class MovieListInteractorOutputSpy: MovieListInteractorOutputProtocol {

    private(set) var fetchedMovies: [Movie]?
    private(set) var fetchedPage: Int?
    private(set) var fetchedHasMore: Bool?
    private(set) var fetchError: AppError?
    private(set) var failedPage: Int?

    func didFetchMovies(_ movies: [Movie], page: Int, hasMore: Bool) {
        fetchedMovies = movies
        fetchedPage = page
        fetchedHasMore = hasMore
    }

    func didFailFetchingMovies(_ error: AppError, page: Int) {
        fetchError = error
        failedPage = page
    }
}

final class MovieListInteractorInputSpy: MovieListInteractorInputProtocol {

    private(set) var fetchRequests: [(genreID: Int, page: Int)] = []

    func fetchMovies(genreID: Int, page: Int) {
        fetchRequests.append((genreID, page))
    }
}

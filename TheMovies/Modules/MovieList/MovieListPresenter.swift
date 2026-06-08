//
//  MovieListPresenter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class MovieListPresenter: MovieListPresenterProtocol {

    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorInputProtocol?
    var router: MovieListRouterProtocol?

    private let genre: Genre
    private var movies: [Movie] = []
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoading = false

    init(genre: Genre) {
        self.genre = genre
    }

    func viewDidLoad() {
        view?.setTitle(genre.name)
        loadFirstPage()
    }

    func didSelectMovie(at index: Int) {
        guard movies.indices.contains(index) else { return }
        router?.navigateToMovieDetail(movieID: movies[index].id)
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isLoading, hasMorePages else { return }
        let thresholdIndex = movies.count - 4
        guard currentIndex >= thresholdIndex else { return }
        loadPage(currentPage + 1)
    }

    func retryTapped() {
        if movies.isEmpty {
            loadFirstPage()
        } else if hasMorePages {
            loadPage(currentPage + 1)
        }
    }

    private func loadFirstPage() {
        movies = []
        currentPage = 1
        hasMorePages = true
        loadPage(1)
    }

    private func loadPage(_ page: Int) {
        guard !isLoading else { return }
        isLoading = true

        if page == 1 {
            view?.showLoading()
        } else {
            view?.showFooterLoading(true)
        }

        interactor?.fetchMovies(genreID: genre.id, page: page)
    }
}

extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func didFetchMovies(_ movies: [Movie], page: Int, hasMore: Bool) {
        isLoading = false
        currentPage = page
        hasMorePages = hasMore

        if page == 1 {
            view?.hideLoading()
            if movies.isEmpty {
                view?.showEmpty()
            } else {
                self.movies = movies
                view?.showMovies(movies)
            }
        } else {
            view?.showFooterLoading(false)
            self.movies.append(contentsOf: movies)
            view?.appendMovies(movies)
        }
    }

    func didFailFetchingMovies(_ error: AppError, page: Int) {
        isLoading = false

        if page == 1 {
            view?.hideLoading()
            view?.showError(error)
        } else {
            view?.showFooterLoading(false)
            view?.showError(error)
        }
    }
}

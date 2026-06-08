//
//  GenreListPresenter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class GenreListPresenter: GenreListPresenterProtocol {

    weak var view: GenreListViewProtocol?
    var interactor: GenreListInteractorInputProtocol?
    var router: GenreListRouterProtocol?

    private var genres: [Genre] = []

    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchGenres()
    }

    func didSelectGenre(at index: Int) {
        guard genres.indices.contains(index) else { return }
        router?.navigateToMovieList(genre: genres[index])
    }

    func retryTapped() {
        view?.showLoading()
        interactor?.fetchGenres()
    }
}

extension GenreListPresenter: GenreListInteractorOutputProtocol {
    func didFetchGenres(_ genres: [Genre]) {
        self.genres = genres
        view?.hideLoading()
        if genres.isEmpty {
            view?.showEmpty()
        } else {
            view?.showGenres(genres)
        }
    }

    func didFailFetchingGenres(_ error: AppError) {
        view?.hideLoading()
        view?.showError(error)
    }
}

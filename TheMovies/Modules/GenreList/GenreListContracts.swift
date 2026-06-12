//
//  GenreListContracts.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

// MARK: - View

protocol GenreListViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showGenres(_ genres: [Genre])
    func showEmpty()
    func showError(_ error: AppError)
}

// MARK: - Presenter

protocol GenreListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectGenre(at index: Int)
    func retryTapped()
}

// MARK: - Interactor

protocol GenreListInteractorInputProtocol: AnyObject {
    func fetchGenres()
}

protocol GenreListInteractorOutputProtocol: AnyObject {
    func didFetchGenres(_ genres: [Genre])
    func didFailFetchingGenres(_ error: AppError)
}

// MARK: - Router

protocol GenreListRouterProtocol: AnyObject {
    func navigateToMovieList(genre: Genre)
}

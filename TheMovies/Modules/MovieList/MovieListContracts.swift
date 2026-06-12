//
//  MovieListContracts.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func setTitle(_ title: String)
    func showLoading()
    func hideLoading()
    func showMovies(_ movies: [Movie])
    func appendMovies(_ movies: [Movie])
    func showEmpty()
    func showError(_ error: AppError)
    func showFooterLoading(_ isLoading: Bool)
}

protocol MovieListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectMovie(at index: Int)
    func loadNextPageIfNeeded(currentIndex: Int)
    func retryTapped()
}

protocol MovieListInteractorInputProtocol: AnyObject {
    func fetchMovies(genreID: Int, page: Int)
}

protocol MovieListInteractorOutputProtocol: AnyObject {
    func didFetchMovies(_ movies: [Movie], page: Int, hasMore: Bool)
    func didFailFetchingMovies(_ error: AppError, page: Int)
}

protocol MovieListRouterProtocol: AnyObject {
    func navigateToMovieDetail(movieID: Int)
}

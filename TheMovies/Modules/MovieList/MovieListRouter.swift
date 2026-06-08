//
//  MovieListRouter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class MovieListRouter: MovieListRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(genre: Genre) -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter(genre: genre)
        let interactor = MovieListInteractor()
        let router = MovieListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToMovieDetail(movieID: Int) {
        let detailVC = MovieDetailRouter.createModule(movieID: movieID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

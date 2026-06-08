//
//  GenreListRouter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class GenreListRouter: GenreListRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UINavigationController {
        let view = GenreListViewController()
        let presenter = GenreListPresenter()
        let interactor = GenreListInteractor()
        let router = GenreListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }

    func navigateToMovieList(genre: Genre) {
        let movieListVC = MovieListRouter.createModule(genre: genre)
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }
}

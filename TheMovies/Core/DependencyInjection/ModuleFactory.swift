//
//  ModuleFactory.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

/// Builds VIPER modules by injecting dependencies from outside each class.
final class ModuleFactory {

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func makeGenreListModule() -> UINavigationController {
        let view = GenreListViewController()
        let presenter = GenreListPresenter()
        let interactor = GenreListInteractor(apiClient: dependencies.apiClient)
        let router = GenreListRouter(moduleFactory: self)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return UINavigationController(rootViewController: view)
    }

    func makeMovieListModule(genre: Genre) -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter(genre: genre)
        let interactor = MovieListInteractor(apiClient: dependencies.apiClient)
        let router = MovieListRouter(moduleFactory: self)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func makeMovieDetailModule(movieID: Int) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter(movieID: movieID)
        let interactor = MovieDetailInteractor(apiClient: dependencies.apiClient)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter

        return view
    }
}

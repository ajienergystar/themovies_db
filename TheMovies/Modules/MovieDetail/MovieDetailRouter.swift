//
//  MovieDetailRouter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class MovieDetailRouter: MovieDetailRouterProtocol {

    static func createModule(movieID: Int) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter(movieID: movieID)
        let interactor = MovieDetailInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter

        return view
    }
}

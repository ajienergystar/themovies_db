//
//  MovieListRouter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class MovieListRouter: MovieListRouterProtocol {

    weak var viewController: UIViewController?

    private let moduleFactory: ModuleFactory

    init(moduleFactory: ModuleFactory) {
        self.moduleFactory = moduleFactory
    }

    func navigateToMovieDetail(movieID: Int) {
        let detailVC = moduleFactory.makeMovieDetailModule(movieID: movieID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

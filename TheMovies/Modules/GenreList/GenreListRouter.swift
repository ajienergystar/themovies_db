//
//  GenreListRouter.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class GenreListRouter: GenreListRouterProtocol {

    weak var viewController: UIViewController?

    private let moduleFactory: ModuleFactory

    init(moduleFactory: ModuleFactory) {
        self.moduleFactory = moduleFactory
    }

    func navigateToMovieList(genre: Genre) {
        let movieListVC = moduleFactory.makeMovieListModule(genre: genre)
        viewController?.navigationController?.pushViewController(movieListVC, animated: true)
    }
}

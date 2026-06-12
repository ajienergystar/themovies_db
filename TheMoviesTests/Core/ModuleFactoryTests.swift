//
//  ModuleFactoryTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import UIKit
@testable import TheMovies

@MainActor
struct ModuleFactoryTests {

    private func makeFactory() -> ModuleFactory {
        let dependencies = TestDependencies(apiClient: MockAPIClient())
        return ModuleFactory(dependencies: dependencies)
    }

    @Test
    func makeGenreListModule_returnsNavigationControllerWithWiredVIPER() {
        let factory = makeFactory()

        let navigationController = factory.makeGenreListModule()

        guard let viewController = navigationController.viewControllers.first as? GenreListViewController else {
            Issue.record("Expected GenreListViewController as root")
            return
        }
        #expect(viewController.presenter != nil)
    }

    @Test
    func makeMovieListModule_returnsWiredViewController() {
        let factory = makeFactory()
        let genre = Genre(id: 28, name: "Action")

        let viewController = factory.makeMovieListModule(genre: genre)

        guard let movieListViewController = viewController as? MovieListViewController else {
            Issue.record("Expected MovieListViewController")
            return
        }
        #expect(movieListViewController.presenter != nil)
    }

    @Test
    func makeMovieDetailModule_returnsWiredViewController() {
        let factory = makeFactory()

        let viewController = factory.makeMovieDetailModule(movieID: 550)

        guard let movieDetailViewController = viewController as? MovieDetailViewController else {
            Issue.record("Expected MovieDetailViewController")
            return
        }
        #expect(movieDetailViewController.presenter != nil)
    }
}

//
//  TestDependencies.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//

@testable import TheMovies

struct TestDependencies: AppDependencies {
    let apiClient: APIClientProtocol
}

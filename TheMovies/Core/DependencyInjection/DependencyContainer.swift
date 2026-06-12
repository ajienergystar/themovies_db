//
//  DependencyContainer.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

/// Composition root that registers and resolves shared application dependencies.
final class DependencyContainer: AppDependencies {

    let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    /// Production container with default service implementations.
    static func makeDefault() -> DependencyContainer {
        DependencyContainer(apiClient: APIClient(session: .shared))
    }
}

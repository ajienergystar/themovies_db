//
//  AppDependencies.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

/// Contract for application-wide dependencies injected from the composition root.
protocol AppDependencies {
    var apiClient: APIClientProtocol { get }
}

//
//  APIClientProtocol.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: TMDBEndpoint, type: T.Type) async throws -> T
}

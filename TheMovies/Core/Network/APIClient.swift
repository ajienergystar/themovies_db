//
//  APIClient.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class APIClient: APIClientProtocol {

    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func request<T: Decodable>(_ endpoint: TMDBEndpoint, type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw AppError.invalidResponse
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            throw AppError.networkUnavailable
        } catch {
            throw AppError.custom(message: error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AppError.decodingFailed
        }
    }
}

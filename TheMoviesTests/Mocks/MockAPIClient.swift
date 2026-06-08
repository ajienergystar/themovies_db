//
//  MockAPIClient.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation
@testable import TheMovies

final class MockAPIClient: APIClientProtocol {

    private(set) var requestCallCount = 0
    private(set) var requestedEndpoints: [TMDBEndpoint] = []

    var genreListResult: Result<GenreListResponse, Error>?
    var discoverMoviesResult: Result<MovieListResponse, Error>?
    var movieDetailResult: Result<MovieDetail, Error>?
    var reviewListResult: Result<ReviewListResponse, Error>?
    var videoListResult: Result<VideoListResponse, Error>?

    func request<T: Decodable>(_ endpoint: TMDBEndpoint, type: T.Type) async throws -> T {
        requestCallCount += 1
        requestedEndpoints.append(endpoint)

        switch endpoint {
        case .genreList:
            return try castResult(genreListResult, as: T.self)
        case .discoverMovies:
            return try castResult(discoverMoviesResult, as: T.self)
        case .movieDetail:
            return try castResult(movieDetailResult, as: T.self)
        case .movieReviews:
            return try castResult(reviewListResult, as: T.self)
        case .movieVideos:
            return try castResult(videoListResult, as: T.self)
        }
    }

    private func castResult<T: Decodable, U>(_ result: Result<U, Error>?, as type: T.Type) throws -> T {
        guard let result else {
            throw AppError.emptyData
        }
        switch result {
        case .success(let value):
            guard let typedValue = value as? T else {
                throw AppError.decodingFailed
            }
            return typedValue
        case .failure(let error):
            throw error
        }
    }
}

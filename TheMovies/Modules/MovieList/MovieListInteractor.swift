//
//  MovieListInteractor.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class MovieListInteractor: MovieListInteractorInputProtocol {

    weak var output: MovieListInteractorOutputProtocol?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovies(genreID: Int, page: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response: MovieListResponse = try await apiClient.request(
                    .discoverMovies(genreID: genreID, page: page),
                    type: MovieListResponse.self
                )
                let hasMore = response.page < response.totalPages
                await MainActor.run {
                    self.output?.didFetchMovies(response.results, page: page, hasMore: hasMore)
                }
            } catch let error as AppError {
                await MainActor.run {
                    self.output?.didFailFetchingMovies(error, page: page)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailFetchingMovies(.custom(message: error.localizedDescription), page: page)
                }
            }
        }
    }
}

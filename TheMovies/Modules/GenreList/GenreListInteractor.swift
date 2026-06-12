//
//  GenreListInteractor.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class GenreListInteractor: GenreListInteractorInputProtocol {

    weak var output: GenreListInteractorOutputProtocol?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchGenres() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response: GenreListResponse = try await apiClient.request(.genreList, type: GenreListResponse.self)
                let genres = response.genres.sorted { $0.name < $1.name }
                await MainActor.run {
                    self.output?.didFetchGenres(genres)
                }
            } catch let error as AppError {
                await MainActor.run {
                    self.output?.didFailFetchingGenres(error)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailFetchingGenres(.custom(message: error.localizedDescription))
                }
            }
        }
    }
}

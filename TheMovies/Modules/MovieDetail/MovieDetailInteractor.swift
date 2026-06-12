//
//  MovieDetailInteractor.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

final class MovieDetailInteractor: MovieDetailInteractorInputProtocol {

    weak var output: MovieDetailInteractorOutputProtocol?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchMovieDetail(id: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let detail: MovieDetail = try await apiClient.request(.movieDetail(id: id), type: MovieDetail.self)
                await MainActor.run {
                    self.output?.didFetchMovieDetail(detail)
                }
            } catch let error as AppError {
                await MainActor.run {
                    self.output?.didFailWithError(error, context: .detail)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailWithError(.custom(message: error.localizedDescription), context: .detail)
                }
            }
        }
    }

    func fetchReviews(movieID: Int, page: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response: ReviewListResponse = try await apiClient.request(
                    .movieReviews(id: movieID, page: page),
                    type: ReviewListResponse.self
                )
                let hasMore = response.page < response.totalPages
                await MainActor.run {
                    self.output?.didFetchReviews(response.results, page: page, hasMore: hasMore)
                }
            } catch let error as AppError {
                await MainActor.run {
                    self.output?.didFailWithError(error, context: .reviews(page: page))
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailWithError(
                        .custom(message: error.localizedDescription),
                        context: .reviews(page: page)
                    )
                }
            }
        }
    }

    func fetchVideos(movieID: Int) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response: VideoListResponse = try await apiClient.request(
                    .movieVideos(id: movieID),
                    type: VideoListResponse.self
                )
                let trailerKey = response.results.first(where: \.isYouTubeTrailer)?.key
                await MainActor.run {
                    self.output?.didFetchTrailer(key: trailerKey)
                }
            } catch let error as AppError {
                await MainActor.run {
                    self.output?.didFailWithError(error, context: .videos)
                }
            } catch {
                await MainActor.run {
                    self.output?.didFailWithError(.custom(message: error.localizedDescription), context: .videos)
                }
            }
        }
    }
}

//
//  MovieDetailContracts.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

enum MovieDetailTab: Int, CaseIterable {
    case about
    case reviews
    case trailer

    var title: String {
        switch self {
        case .about: return "About"
        case .reviews: return "Reviews"
        case .trailer: return "Trailer"
        }
    }
}

protocol MovieDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showDetail(_ detail: MovieDetail)
    func showReviews(_ reviews: [Review])
    func appendReviews(_ reviews: [Review])
    func showTrailer(key: String?)
    func showError(_ error: AppError)
    func showReviewsFooterLoading(_ isLoading: Bool)
}

protocol MovieDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTab(_ tab: MovieDetailTab)
    func loadMoreReviewsIfNeeded(currentIndex: Int)
    func retryTapped()
}

protocol MovieDetailInteractorInputProtocol: AnyObject {
    func fetchMovieDetail(id: Int)
    func fetchReviews(movieID: Int, page: Int)
    func fetchVideos(movieID: Int)
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func didFetchMovieDetail(_ detail: MovieDetail)
    func didFetchReviews(_ reviews: [Review], page: Int, hasMore: Bool)
    func didFetchTrailer(key: String?)
    func didFailWithError(_ error: AppError, context: MovieDetailErrorContext)
}

enum MovieDetailErrorContext {
    case detail
    case reviews(page: Int)
    case videos
}

protocol MovieDetailRouterProtocol: AnyObject {
}

//
//  TMDBEndpoint.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

enum TMDBEndpoint {
    case genreList
    case discoverMovies(genreID: Int, page: Int)
    case movieDetail(id: Int)
    case movieReviews(id: Int, page: Int)
    case movieVideos(id: Int)

    var path: String {
        switch self {
        case .genreList:
            return "/genre/movie/list"
        case .discoverMovies:
            return "/discover/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieReviews(let id, _):
            return "/movie/\(id)/reviews"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        }
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem(name: "api_key", value: TMDBConstants.apiKey)]

        switch self {
        case .discoverMovies(let genreID, let page):
            items.append(URLQueryItem(name: "with_genres", value: "\(genreID)"))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .movieReviews(_, let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .genreList, .movieDetail, .movieVideos:
            break
        }

        return items
    }

    var url: URL? {
        var components = URLComponents(string: TMDBConstants.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}

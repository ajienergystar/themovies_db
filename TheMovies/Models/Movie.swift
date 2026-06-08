//
//  Movie.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

struct MovieListResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

struct Movie: Decodable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }

    var releaseYear: String {
        guard let releaseDate, !releaseDate.isEmpty else { return "N/A" }
        return String(releaseDate.prefix(4))
    }

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: TMDBConstants.imageBaseURL + posterPath)
    }
}

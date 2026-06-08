//
//  MovieDetail.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }

    var runtimeText: String {
        guard let runtime, runtime > 0 else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var genreNames: String {
        genres.map(\.name).joined(separator: ", ")
    }

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: TMDBConstants.imageBaseURL + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: TMDBConstants.backdropBaseURL + backdropPath)
    }
}

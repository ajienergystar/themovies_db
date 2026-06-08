//
//  TestFixtures.swift
//  TheMoviesTests
//

import Foundation
@testable import TheMovies

enum TestFixtures {

    static func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: Data(json.utf8))
    }

    // MARK: - Genre

    static let genreListJSON = """
    {
        "genres": [
            { "id": 28, "name": "Action" },
            { "id": 12, "name": "Adventure" },
            { "id": 35, "name": "Comedy" }
        ]
    }
    """

    static var genres: [Genre] {
        get throws { try decode(GenreListResponse.self, from: genreListJSON).genres }
    }

    static var sampleGenre: Genre {
        get throws { try genres[0] }
    }

    // MARK: - Movie

    static let movieJSON = """
    {
        "id": 550,
        "title": "Fight Club",
        "overview": "A ticking-time-bomb insomniac.",
        "poster_path": "/poster.jpg",
        "backdrop_path": "/backdrop.jpg",
        "vote_average": 8.4,
        "release_date": "1999-10-15"
    }
    """

    static let movieListJSON = """
    {
        "page": 1,
        "results": [
            {
                "id": 550,
                "title": "Fight Club",
                "overview": "Overview",
                "poster_path": "/poster.jpg",
                "backdrop_path": null,
                "vote_average": 8.4,
                "release_date": "1999-10-15"
            },
            {
                "id": 551,
                "title": "Se7en",
                "overview": null,
                "poster_path": null,
                "backdrop_path": null,
                "vote_average": 8.3,
                "release_date": ""
            }
        ],
        "total_pages": 3,
        "total_results": 60
    }
    """

    static var sampleMovie: Movie {
        get throws { try decode(Movie.self, from: movieJSON) }
    }

    static var movieListResponse: MovieListResponse {
        get throws { try decode(MovieListResponse.self, from: movieListJSON) }
    }

    // MARK: - Movie Detail

    static let movieDetailJSON = """
    {
        "id": 550,
        "title": "Fight Club",
        "overview": "A ticking-time-bomb insomniac.",
        "poster_path": "/poster.jpg",
        "backdrop_path": "/backdrop.jpg",
        "vote_average": 8.4,
        "release_date": "1999-10-15",
        "runtime": 139,
        "genres": [
            { "id": 18, "name": "Drama" },
            { "id": 53, "name": "Thriller" }
        ],
        "tagline": "Mischief. Mayhem. Soap."
    }
    """

    static var sampleMovieDetail: MovieDetail {
        get throws { try decode(MovieDetail.self, from: movieDetailJSON) }
    }

    // MARK: - Review

    static let reviewJSON = """
    {
        "id": "abc123",
        "author": "John Doe",
        "content": "Great movie!",
        "created_at": "2024-01-15T10:30:00.000Z"
    }
    """

    static let reviewListJSON = """
    {
        "page": 1,
        "results": [
            {
                "id": "abc123",
                "author": "John Doe",
                "content": "Great movie!",
                "created_at": "2024-01-15T10:30:00.000Z"
            }
        ],
        "total_pages": 2,
        "total_results": 15
    }
    """

    static var sampleReview: Review {
        get throws { try decode(Review.self, from: reviewJSON) }
    }

    static var reviewListResponse: ReviewListResponse {
        get throws { try decode(ReviewListResponse.self, from: reviewListJSON) }
    }

    // MARK: - Video

    static let videoJSON = """
    {
        "id": "video1",
        "key": "dQw4w9WgXcQ",
        "name": "Official Trailer",
        "site": "YouTube",
        "type": "Trailer"
    }
    """

    static let videoListJSON = """
    {
        "results": [
            {
                "id": "video1",
                "key": "dQw4w9WgXcQ",
                "name": "Official Trailer",
                "site": "YouTube",
                "type": "Trailer"
            },
            {
                "id": "video2",
                "key": "otherKey",
                "name": "Teaser",
                "site": "YouTube",
                "type": "Teaser"
            }
        ]
    }
    """

    static var sampleVideo: Video {
        get throws { try decode(Video.self, from: videoJSON) }
    }

    static var videoListResponse: VideoListResponse {
        get throws { try decode(VideoListResponse.self, from: videoListJSON) }
    }
}

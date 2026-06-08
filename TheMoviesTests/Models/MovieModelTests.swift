//
//  MovieModelTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheMovies

@Suite("Movie Models")
struct MovieModelTests {

    @Test("Movie decodes snake_case JSON")
    func decodeMovie() throws {
        let movie = try TestFixtures.sampleMovie
        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
        #expect(movie.voteAverage == 8.4)
        #expect(movie.posterPath == "/poster.jpg")
    }

    @Test("MovieListResponse decodes pagination metadata")
    func decodeMovieList() throws {
        let response = try TestFixtures.movieListResponse
        #expect(response.page == 1)
        #expect(response.totalPages == 3)
        #expect(response.totalResults == 60)
        #expect(response.results.count == 2)
    }

    @Test("ratingText formats vote average to one decimal")
    func ratingText() throws {
        let movie = try TestFixtures.sampleMovie
        #expect(movie.ratingText == "8.4")
    }

    @Test("releaseYear extracts year from release date")
    func releaseYear() throws {
        let movie = try TestFixtures.sampleMovie
        #expect(movie.releaseYear == "1999")

        let list = try TestFixtures.movieListResponse
        #expect(list.results[1].releaseYear == "N/A")
    }

    @Test("posterURL builds image URL from poster path")
    func posterURL() throws {
        let movie = try TestFixtures.sampleMovie
        #expect(movie.posterURL?.absoluteString == TMDBConstants.imageBaseURL + "/poster.jpg")

        let list = try TestFixtures.movieListResponse
        #expect(list.results[1].posterURL == nil)
    }
}

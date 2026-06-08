//
//  MovieDetailModelTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Testing
@testable import TheMovies

@Suite("MovieDetail Model")
struct MovieDetailModelTests {

    @Test("MovieDetail decodes nested genres")
    func decodeMovieDetail() throws {
        let detail = try TestFixtures.sampleMovieDetail
        #expect(detail.id == 550)
        #expect(detail.runtime == 139)
        #expect(detail.genres.count == 2)
        #expect(detail.tagline == "Mischief. Mayhem. Soap.")
    }

    @Test("runtimeText formats hours and minutes")
    func runtimeText() throws {
        let detail = try TestFixtures.sampleMovieDetail
        #expect(detail.runtimeText == "2h 19m")
    }

    @Test("runtimeText returns N/A when runtime is missing")
    func runtimeTextMissing() throws {
        let json = TestFixtures.movieDetailJSON.replacingOccurrences(of: "\"runtime\": 139", with: "\"runtime\": null")
        let detail = try TestFixtures.decode(MovieDetail.self, from: json)
        #expect(detail.runtimeText == "N/A")
    }

    @Test("runtimeText handles sub-hour runtime")
    func runtimeTextMinutesOnly() throws {
        let json = TestFixtures.movieDetailJSON.replacingOccurrences(of: "\"runtime\": 139", with: "\"runtime\": 45")
        let detail = try TestFixtures.decode(MovieDetail.self, from: json)
        #expect(detail.runtimeText == "45m")
    }

    @Test("genreNames joins genre names")
    func genreNames() throws {
        let detail = try TestFixtures.sampleMovieDetail
        #expect(detail.genreNames == "Drama, Thriller")
    }

    @Test("backdropURL uses backdrop base URL")
    func backdropURL() throws {
        let detail = try TestFixtures.sampleMovieDetail
        #expect(detail.backdropURL?.absoluteString == TMDBConstants.backdropBaseURL + "/backdrop.jpg")
    }
}

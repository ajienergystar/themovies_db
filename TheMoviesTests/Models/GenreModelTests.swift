//
//  GenreModelTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("Genre Models")
struct GenreModelTests {

    @Test("GenreListResponse decodes from API JSON")
    func decodeGenreList() throws {
        let response = try TestFixtures.decode(GenreListResponse.self, from: TestFixtures.genreListJSON)
        #expect(response.genres.count == 3)
        #expect(response.genres.map(\.name) == ["Action", "Adventure", "Comedy"])
    }

    @Test("Genre is Hashable")
    func genreHashable() throws {
        let genres = try TestFixtures.genres
        let set = Set(genres)
        #expect(set.count == genres.count)
    }
}

//
//  TMDBEndpointTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("TMDBEndpoint")
struct TMDBEndpointTests {

    @Test("path matches TMDb API routes")
    func paths() {
        #expect(TMDBEndpoint.genreList.path == "/genre/movie/list")
        #expect(TMDBEndpoint.discoverMovies(genreID: 28, page: 1).path == "/discover/movie")
        #expect(TMDBEndpoint.movieDetail(id: 550).path == "/movie/550")
        #expect(TMDBEndpoint.movieReviews(id: 550, page: 2).path == "/movie/550/reviews")
        #expect(TMDBEndpoint.movieVideos(id: 550).path == "/movie/550/videos")
    }

    @Test("queryItems include api_key for all endpoints")
    func apiKeyIncluded() {
        let endpoints: [TMDBEndpoint] = [
            .genreList,
            .discoverMovies(genreID: 28, page: 1),
            .movieDetail(id: 1),
            .movieReviews(id: 1, page: 1),
            .movieVideos(id: 1)
        ]

        for endpoint in endpoints {
            let items = endpoint.queryItems
            #expect(items.contains { $0.name == "api_key" && $0.value == TMDBConstants.apiKey })
        }
    }

    @Test("discoverMovies adds genre and page query parameters")
    func discoverMoviesQueryItems() {
        let items = TMDBEndpoint.discoverMovies(genreID: 35, page: 3).queryItems
        #expect(items.contains { $0.name == "with_genres" && $0.value == "35" })
        #expect(items.contains { $0.name == "page" && $0.value == "3" })
    }

    @Test("movieReviews adds page query parameter")
    func movieReviewsQueryItems() {
        let items = TMDBEndpoint.movieReviews(id: 99, page: 4).queryItems
        #expect(items.contains { $0.name == "page" && $0.value == "4" })
    }

    @Test("url builds valid HTTPS request URL")
    func urlConstruction() throws {
        let url = try #require(TMDBEndpoint.genreList.url)
        #expect(url.scheme == "https")
        #expect(url.host == "api.themoviedb.org")
        #expect(url.path == "/3/genre/movie/list")
        #expect(url.absoluteString.contains("api_key="))
    }
}

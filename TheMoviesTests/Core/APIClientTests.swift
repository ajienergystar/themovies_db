//
//  APIClientTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
import Testing
@testable import TheMovies

@Suite("APIClient")
struct APIClientTests {

    @Test("decodes successful JSON response")
    func successfulRequest() async throws {
        let session = URLSession.stubbed { request in
            let response = HTTPURLResponse(
                url: try #require(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data(TestFixtures.genreListJSON.utf8))
        }
        defer { URLProtocolStub.requestHandler = nil }

        let client = APIClient(session: session)
        let result: GenreListResponse = try await client.request(.genreList, type: GenreListResponse.self)

        #expect(result.genres.count == 3)
        #expect(result.genres.first?.name == "Action")
    }

    @Test("throws serverError for non-2xx status codes")
    func serverError() async {
        let session = URLSession.stubbed { request in
            let response = HTTPURLResponse(
                url: try #require(request.url),
                statusCode: 503,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        defer { URLProtocolStub.requestHandler = nil }

        let client = APIClient(session: session)

        await #expect(throws: AppError.serverError(statusCode: 503)) {
            _ = try await client.request(.genreList, type: GenreListResponse.self)
        }
    }

    @Test("throws decodingFailed for invalid JSON")
    func decodingFailed() async {
        let session = URLSession.stubbed { request in
            let response = HTTPURLResponse(
                url: try #require(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("{ invalid json".utf8))
        }
        defer { URLProtocolStub.requestHandler = nil }

        let client = APIClient(session: session)

        await #expect(throws: AppError.decodingFailed) {
            _ = try await client.request(.genreList, type: GenreListResponse.self)
        }
    }

    @Test("throws networkUnavailable for offline URLError")
    func networkUnavailable() async {
        let session = URLSession.stubbed { _ in
            throw URLError(.notConnectedToInternet)
        }
        defer { URLProtocolStub.requestHandler = nil }

        let client = APIClient(session: session)

        await #expect(throws: AppError.networkUnavailable) {
            _ = try await client.request(.genreList, type: GenreListResponse.self)
        }
    }

    @Test("throws custom error for other URL session failures")
    func customNetworkError() async {
        let session = URLSession.stubbed { _ in
            throw URLError(.timedOut)
        }
        defer { URLProtocolStub.requestHandler = nil }

        let client = APIClient(session: session)

        await #expect(throws: AppError.self) {
            _ = try await client.request(.genreList, type: GenreListResponse.self)
        }
    }
}

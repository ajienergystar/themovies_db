//
//  ReviewModelTests.swift
//  TheMoviesTests
//
//  Created by Aji Prakosa on 08/06/26.
//


import Testing
@testable import TheMovies

@Suite("Review Models")
struct ReviewModelTests {

    @Test("Review decodes from API JSON")
    func decodeReview() throws {
        let review = try TestFixtures.sampleReview
        #expect(review.id == "abc123")
        #expect(review.author == "John Doe")
        #expect(review.content == "Great movie!")
        #expect(review.createdAt == "2024-01-15T10:30:00.000Z")
    }

    @Test("ReviewListResponse decodes pagination")
    func decodeReviewList() throws {
        let response = try TestFixtures.reviewListResponse
        #expect(response.page == 1)
        #expect(response.totalPages == 2)
        #expect(response.results.count == 1)
    }

    @Test("formattedDate parses ISO8601 with fractional seconds")
    func formattedDateWithFractionalSeconds() throws {
        let review = try TestFixtures.sampleReview
        #expect(review.formattedDate.isEmpty == false)
        #expect(review.formattedDate != review.createdAt)
    }

    @Test("formattedDate returns empty string when createdAt is nil")
    func formattedDateNil() throws {
        let json = """
        {
            "id": "x",
            "author": "A",
            "content": "C",
            "created_at": null
        }
        """
        let review = try TestFixtures.decode(Review.self, from: json)
        #expect(review.formattedDate == "")
    }

    @Test("formattedDate falls back to raw string for unparseable date")
    func formattedDateFallback() throws {
        let json = """
        {
            "id": "x",
            "author": "A",
            "content": "C",
            "created_at": "not-a-date"
        }
        """
        let review = try TestFixtures.decode(Review.self, from: json)
        #expect(review.formattedDate == "not-a-date")
    }
}

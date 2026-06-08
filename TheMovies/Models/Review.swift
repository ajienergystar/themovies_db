//
//  Review.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

struct ReviewListResponse: Decodable {
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
}

struct Review: Decodable, Hashable {
    let id: String
    let author: String
    let content: String
    let createdAt: String?

    var formattedDate: String {
        guard let createdAt else { return "" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: createdAt) {
            return DateFormatter.reviewDisplay.string(from: date)
        }
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: createdAt) {
            return DateFormatter.reviewDisplay.string(from: date)
        }
        return createdAt
    }
}

private extension DateFormatter {
    static let reviewDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

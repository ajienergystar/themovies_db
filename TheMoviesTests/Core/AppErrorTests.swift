//
//  AppErrorTests.swift
//  TheMoviesTests
//

import Testing
@testable import TheMovies

@Suite("AppError")
struct AppErrorTests {

    @Test("errorDescription returns user-friendly messages")
    func errorDescriptions() {
        #expect(AppError.networkUnavailable.errorDescription == "No internet connection. Please check your network and try again.")
        #expect(AppError.invalidResponse.errorDescription == "Received an invalid response from the server.")
        #expect(AppError.decodingFailed.errorDescription == "Failed to process the server response.")
        #expect(AppError.serverError(statusCode: 500).errorDescription == "Server error (500). Please try again later.")
        #expect(AppError.emptyData.errorDescription == "No data available.")
        #expect(AppError.custom(message: "Custom failure").errorDescription == "Custom failure")
    }

    @Test("recoverySuggestion guides user actions")
    func recoverySuggestions() {
        #expect(AppError.networkUnavailable.recoverySuggestion == "Check your connection and tap Retry.")
        #expect(AppError.invalidResponse.recoverySuggestion == "Tap Retry to load again.")
        #expect(AppError.decodingFailed.recoverySuggestion == "Tap Retry to load again.")
        #expect(AppError.serverError(statusCode: 404).recoverySuggestion == "Tap Retry to load again.")
        #expect(AppError.emptyData.recoverySuggestion == nil)
        #expect(AppError.custom(message: "Oops").recoverySuggestion == "Tap Retry to load again.")
    }

    @Test("equatable compares cases correctly")
    func equatable() {
        #expect(AppError.networkUnavailable == AppError.networkUnavailable)
        #expect(AppError.serverError(statusCode: 401) == AppError.serverError(statusCode: 401))
        #expect(AppError.serverError(statusCode: 401) != AppError.serverError(statusCode: 403))
        #expect(AppError.custom(message: "A") == AppError.custom(message: "A"))
        #expect(AppError.custom(message: "A") != AppError.custom(message: "B"))
    }
}

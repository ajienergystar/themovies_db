//
//  AppError.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case networkUnavailable
    case invalidResponse
    case decodingFailed
    case serverError(statusCode: Int)
    case emptyData
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Please check your network and try again."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingFailed:
            return "Failed to process the server response."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        case .emptyData:
            return "No data available."
        case .custom(let message):
            return message
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your connection and tap Retry."
        case .invalidResponse, .decodingFailed, .serverError:
            return "Tap Retry to load again."
        case .emptyData:
            return nil
        case .custom:
            return "Tap Retry to load again."
        }
    }
}

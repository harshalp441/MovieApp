//
//  APIError.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid server response."

        case .httpError(let statusCode):
            return "Server returned status code \(statusCode)."

        case .decodingError:
            return "Unable to decode server response."

        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

//
//  APIError.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Int)
    case noData
    case decodingFailed
    case noResults

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let statusCode):
            return "Request failed with status code \(statusCode)."
        case .noData:
            return "No data received from the server."
        case .decodingFailed:
            return "Failed to decode the response."
        case .noResults:
            return "No results were found."
        }
    }
}

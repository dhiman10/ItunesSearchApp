//
//  TestHelpers.swift
//  ItunesSearchAppTests
//

import Foundation
@testable import ItunesSearchApp

// Returns responses in the order they were supplied — used for pagination
// tests where each call needs different data.
actor SequentialMockAPIService: APIServiceProtocal {
    private let responses: [Data]
    private var callIndex = 0

    init(responses: [Data]) {
        self.responses = responses
    }

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard callIndex < responses.count else {
            throw APIError.invalidURL
        }
        let data = responses[callIndex]
        callIndex += 1
        return try JSONDecoder().decode(T.self, from: data)
    }
}

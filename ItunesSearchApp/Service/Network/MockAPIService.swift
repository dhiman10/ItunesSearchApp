//
//  MockAPIService.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 14.12.25.
//
import Foundation

struct MockAPIService: APIServiceProtocal {

    let responses: [String: Data]

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let key = endpoint.debugKey

        guard let data = responses[key] else {
            throw APIError.invalidURL
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

//
//  APIServiceProtocal.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

protocol APIServiceProtocal {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

struct APIService: APIServiceProtocal {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        
        guard let url = endpoint.createURL() else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw APIError.requestFailed(http.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}

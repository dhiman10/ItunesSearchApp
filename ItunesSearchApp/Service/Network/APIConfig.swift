//
//  APIConfig.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//
import Foundation

enum APIConfig {
    static let scheme = "https"
    static let host = "itunes.apple.com"
}

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var debugKey: String { get }   // 👈 add this
}

extension Endpoint {
    var debugKey: String {
        "\(path)?\(queryItems)"
    }
}

extension Endpoint {
    func createURL() -> URL? {
        var components = URLComponents()
        components.scheme = APIConfig.scheme
        components.host = APIConfig.host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

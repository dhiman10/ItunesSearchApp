//
//  ITunesEndpoint.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

enum ITunesEndpoint: Endpoint {
    case search(
        term: String,
        entity: String,
        limit: Int,
        offset: Int
    )
    case lookup(
        id: Int,
        entity: String
    )

    var path: String {
        switch self {
        case .search:
            return "/search"
        case .lookup:
            return "/lookup"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .search(term: term, entity: entity, limit: limit, offset: offset):
            return [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "entity", value: entity),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)"),
            ]

        case let .lookup(id: id, entity: entity):
            return [
                URLQueryItem(name: "id", value: "\(id)"),
                URLQueryItem(name: "entity", value: entity),
            ]
        }
    }

    var debugKey: String {
        switch self {
        case .search: return "search"
        case .lookup: return "lookup"
        }
    }
}

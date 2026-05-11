//
//  AlbumResult.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI
struct AlbumResult: Codable {
    let resultCount: Int
    let results: [Album]
}

// MARK: - Result
struct Album: Codable, Identifiable, Hashable {
    let wrapperType, collectionType: String
    let id: Int
    let artistID: Int
    let amgArtistID: Int?
    let artistName, collectionName, collectionCensoredName: String
    let artistViewURL: String?
    let collectionViewURL: String
    let artworkUrl60, artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country, currency: String
    let releaseDate: String
    let primaryGenreName: String
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case id = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName
    }
    
    
    
}

extension Album {

    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = inputFormatter.date(from: releaseDate) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = .current
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none

        return outputFormatter.string(from: date)
    }
}

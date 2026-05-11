//
//  MusicVideo.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import Foundation

struct MusicVideoResult: Codable {
    let resultCount: Int
    let results: [MusicVideo]
}

struct MusicVideo: Codable, Identifiable {

    // MARK: - Identity
    let id: Int                     // trackId
    let wrapperType: String
    let kind: String                // "music-video"

    // MARK: - Artist / Track
    let artistId: Int
    let artistName: String
    let trackName: String
    let trackCensoredName: String?

    // MARK: - URLs
    let artistViewUrl: String
    let trackViewUrl: String
    let previewUrl: String

    // MARK: - Artwork
    let artworkUrl30: String
    let artworkUrl60: String
    let artworkUrl100: String

    // MARK: - Pricing
    let collectionPrice: Double?
    let trackPrice: Double?

    // MARK: - Meta
    let releaseDate: String
    let trackTimeMillis: Int
    let country: String
    let currency: String
    let primaryGenreName: String

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case kind
        case artistId
        case id = "trackId"
        case artistName
        case trackName
        case trackCensoredName
        case artistViewUrl
        case trackViewUrl
        case previewUrl
        case artworkUrl30
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case trackPrice
        case releaseDate
        case trackTimeMillis
        case country
        case currency
        case primaryGenreName
    }
}

extension MusicVideo {

    static func mockMusic() -> MusicVideo {
        MusicVideo(
            id: 1445891081,
            wrapperType: "track",
            kind: "music-video",
            artistId: 408932,
            artistName: "Rammstein",
            trackName: "Du hast",
            trackCensoredName: "Du hast",
            artistViewUrl: "https://music.apple.com/us/artist/rammstein/408932",
            trackViewUrl: "https://music.apple.com/us/music-video/du-hast/1445891081",
            previewUrl: "https://video-ssl.itunes.apple.com/sample.m4v",
            artworkUrl30: "https://is1-ssl.mzstatic.com/image/thumb/Video126/sample.jpg/30x30bb.jpg",
            artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Video126/sample.jpg/60x60bb.jpg",
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/34/fb/3e/mzi.uphuhrac.tif/100x100bb.jpg",
            collectionPrice: 1.99,
            trackPrice: 1.99,
            releaseDate: "1997-11-18T08:00:00Z",
            trackTimeMillis: 234400,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Heavy Metal"
        )
    }

    static func mockList() -> [MusicVideo] {
        [
            .mockMusic(),
            MusicVideo(
                id: 1445846144,
                wrapperType: "track",
                kind: "music-video",
                artistId: 408932,
                artistName: "Rammstein",
                trackName: "Sonne",
                trackCensoredName: "Sonne",
                artistViewUrl: "https://music.apple.com/us/artist/rammstein/408932",
                trackViewUrl: "https://music.apple.com/us/music-video/sonne/1445846144",
                previewUrl: "https://video-ssl.itunes.apple.com/sample2.m4v",
                artworkUrl30: "https://is1-ssl.mzstatic.com/image/thumb/Video127/sample.jpg/30x30bb.jpg",
                artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Video127/sample.jpg/60x60bb.jpg",
                artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/34/fb/3e/mzi.uphuhrac.tif/100x100bb.jpg",
                collectionPrice: 1.99,
                trackPrice: 1.99,
                releaseDate: "2001-02-12T08:00:00Z",
                trackTimeMillis: 239000,
                country: "USA",
                currency: "USD",
                primaryGenreName: "Heavy Metal"
            )
        ]
    }
}

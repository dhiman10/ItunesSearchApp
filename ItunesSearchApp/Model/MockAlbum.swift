//
//  MockAlbum.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

extension Album {
    static let mockList: [Album] = [
        Album(
            wrapperType: "collection",
            collectionType: "Album",
            id: 1440768692,
            artistID: 909253,
            amgArtistID: 468749,
            artistName: "Jack Johnson",
            collectionName: "In Between Dreams",
            collectionCensoredName: "In Between Dreams",
            artistViewURL: "https://music.apple.com/us/artist/jack-johnson/909253",
            collectionViewURL: "https://music.apple.com/us/album/in-between-dreams/1440768692",
            artworkUrl60: "https://is2-ssl.mzstatic.com/image/thumb/Music114/v4/43/d0/ba/43d0ba6b-6470-ad2d-0c84-171c1daea838/12UMGIM10699.rgb.jpg/60x60bb.jpg",
            artworkUrl100: "https://is2-ssl.mzstatic.com/image/thumb/Music114/v4/43/d0/ba/43d0ba6b-6470-ad2d-0c84-171c1daea838/12UMGIM10699.rgb.jpg/100x100bb.jpg",
            collectionPrice: 9.99,
            collectionExplicitness: "notExplicit",
            trackCount: 14,
            copyright: "℗ 2005 Jack Johnson",
            country: "USA",
            currency: "USD",
            releaseDate: "2005-01-01T08:00:00Z",
            primaryGenreName: "Rock"
        ),

        Album(
            wrapperType: "collection",
            collectionType: "Album",
            id: 906900960,
            artistID: 909253,
            amgArtistID: 468749,
            artistName: "Jack Johnson",
            collectionName: "Brushfire Fairytales (Remastered)",
            collectionCensoredName: "Brushfire Fairytales (Remastered)",
            artistViewURL: "https://music.apple.com/us/artist/jack-johnson/909253",
            collectionViewURL: "https://music.apple.com/us/album/brushfire-fairytales-remastered/906900960",
            artworkUrl60: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/6c/3a/c5.jpg/60x60bb.jpg",
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/6c/3a/c5.jpg/100x100bb.jpg",
            collectionPrice: 9.99,
            collectionExplicitness: "notExplicit",
            trackCount: 15,
            copyright: "℗ 2001 Bubble Toes Music Publishing",
            country: "USA",
            currency: "USD",
            releaseDate: "2001-02-06T08:00:00Z",
            primaryGenreName: "Rock"
        )
    ]
}

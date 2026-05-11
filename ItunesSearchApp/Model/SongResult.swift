//
//  SongResult.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//


import Foundation


// MARK: - SonResult
struct SongResult: Codable {
    let resultCount: Int
    let results: [Song]
}

// MARK: - Result
struct Song: Codable, Identifiable, Hashable {
    let wrapperType: String
    let artistID: Int
    let collectionID: Int
    let id: Int
    let artistName, collectionName, trackName: String
    let artistViewURL, collectionViewURL, trackViewURL: String
    let previewURL: String
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice, trackPrice: Double?
    let releaseDate: String
    let trackCount, trackNumber: Int
    let trackTimeMillis: Int
    let country, currency, primaryGenreName: String
    let collectionArtistName: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType
        case artistID = "artistId"
        case collectionID = "collectionId"
        case id = "trackId"
        case artistName, collectionName, trackName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName,  collectionArtistName
    }
    
    init(wrapperType: String, artistID: Int, collectionID: Int, id: Int, artistName: String, collectionName: String,
         trackName: String, artistViewURL: String, collectionViewURL: String, trackViewURL: String, previewURL: String,
         artworkUrl30: String, artworkUrl60: String, artworkUrl100: String,
         collectionPrice: Double?, trackPrice: Double?, releaseDate: String, trackCount: Int, trackNumber: Int,
         trackTimeMillis: Int, country: String, currency: String, primaryGenreName: String, collectionArtistName: String?) {
        self.wrapperType = wrapperType
        self.id = id
        self.artistID = artistID
        self.collectionID = collectionID
        self.collectionName = collectionName
        self.collectionViewURL = collectionViewURL
        self.collectionArtistName = collectionArtistName
        self.previewURL = previewURL
        
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.currency = currency
        self.country = country
        self.primaryGenreName = primaryGenreName
        
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.artistViewURL = artistViewURL
        self.artistName = artistName
        
        self.trackName = trackName
        self.trackCount = trackCount
        self.trackNumber = trackNumber
        self.trackTimeMillis = trackTimeMillis
        self.trackViewURL = trackViewURL
        self.releaseDate = releaseDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.wrapperType = try container.decode(String.self, forKey: .wrapperType)
        self.artistID = try container.decode(Int.self, forKey: .artistID)
        self.collectionID = try container.decode(Int.self, forKey: .collectionID)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.collectionName = try container.decode(String.self, forKey: .collectionName)
        self.trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        self.artistViewURL = try container.decodeIfPresent(String.self, forKey: .artistViewURL) ?? ""
        self.collectionViewURL = try container.decode(String.self, forKey: .collectionViewURL)
        self.trackViewURL = try container.decodeIfPresent(String.self, forKey: .trackViewURL) ?? ""
        self.previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL) ?? ""
        self.artworkUrl30 = try container.decodeIfPresent(String.self, forKey: .artworkUrl30) ?? ""
        self.artworkUrl60 = try container.decode(String.self, forKey: .artworkUrl60)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        self.collectionPrice = try container.decodeIfPresent(Double.self, forKey: .collectionPrice)
        self.trackPrice = try container.decodeIfPresent(Double.self, forKey: .trackPrice)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
        self.trackNumber = try container.decodeIfPresent(Int.self, forKey: .trackNumber) ?? 1
        self.trackTimeMillis = try container.decodeIfPresent(Int.self, forKey: .trackTimeMillis) ?? 1
        self.country = try container.decode(String.self, forKey: .country)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.primaryGenreName = try container.decode(String.self, forKey: .primaryGenreName)
        self.collectionArtistName = try container.decodeIfPresent(String.self, forKey: .collectionArtistName)
    }
    
    var formattedDuration: String {
        
        let timeInSeconds = trackTimeMillis / 1000
        
        let interval = TimeInterval(timeInSeconds)
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        
        return formatter.string(from: interval) ?? ""
    }
    
    
    static func example() -> Song {
        
    Song(wrapperType: "Song",
         artistID: 1, collectionID: 1, id: 1, artistName: "Jack Johnson",
         collectionName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George",
         trackName: "Upside Down", artistViewURL: "", collectionViewURL: "", trackViewURL: "https://music.apple.com/us/album/upside-down/1469577723?i=1469577741&uo=4", previewURL: "https://is3-ssl.mzstatic.com",
         artworkUrl30: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/30x30bb.jpg", artworkUrl60: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/60x60bb.jpg", artworkUrl100: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/100x100bb.jpg", collectionPrice: 9.88, trackPrice: 1.29, releaseDate: "2005-01-01T12:00:00Z", trackCount: 14, trackNumber: 1, trackTimeMillis: 208643, country: "USA", currency: "USD", primaryGenreName: "Rock", collectionArtistName: nil)
    }
    
    static func example2() -> Song {
        
    Song(wrapperType: "Song",
         artistID: 1, collectionID: 1, id: 10, artistName: "Jack Johnson",
         collectionName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George",
         trackName: "Upside", artistViewURL: "", collectionViewURL: "", trackViewURL: "https://music.apple.com/us/album/upside-down/1469577723?i=1469577741&uo=4", previewURL: "https://is3-ssl.mzstatic.com",
         artworkUrl30: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/30x30bb.jpg", artworkUrl60: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/60x60bb.jpg", artworkUrl100: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/100x100bb.jpg", collectionPrice: 9.88, trackPrice: 0.99, releaseDate: "2005-01-01T12:00:00Z", trackCount: 14, trackNumber: 10, trackTimeMillis: 108643, country: "USA", currency: "USD", primaryGenreName: "Rock", collectionArtistName: nil)
    }
    
    static func example3() -> Song {
        
    Song(wrapperType: "Song",
         artistID: 1, collectionID: 3, id: 10, artistName: "Jack Johnson",
         collectionName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George",
         trackName: "Upside", artistViewURL: "", collectionViewURL: "", trackViewURL: "https://music.apple.com/us/album/upside-down/1469577723?i=1469577741&uo=4", previewURL: "https://is3-ssl.mzstatic.com",
         artworkUrl30: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/30x30bb.jpg", artworkUrl60: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/60x60bb.jpg", artworkUrl100: "https://is3-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/100x100bb.jpg", collectionPrice: 9.88, trackPrice: 0.99, releaseDate: "2005-01-01T12:00:00Z", trackCount: 14, trackNumber: 10, trackTimeMillis: 108643, country: "USA", currency: "USD", primaryGenreName: "Rock", collectionArtistName: nil)
    }
    
}

extension Song {

    static func example4() -> Song {
        Song(
            wrapperType: "track",
            artistID: 2,
            collectionID: 2,
            id: 20,
            artistName: "Coldplay",
            collectionName: "Parachutes",
            trackName: "Yellow",
            artistViewURL: "",
            collectionViewURL: "",
            trackViewURL: "",
            previewURL: "",
            artworkUrl30: artwork,
            artworkUrl60: artwork,
            artworkUrl100: artwork,
            collectionPrice: 11.99,
            trackPrice: 1.29,
            releaseDate: "2000-07-10T00:00:00Z",
            trackCount: 10,
            trackNumber: 5,
            trackTimeMillis: 269000,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Alternative",
            collectionArtistName: nil
        )
    }

    static func example5() -> Song {
        Song(
            wrapperType: "track",
            artistID: 3,
            collectionID: 3,
            id: 30,
            artistName: "Imagine Dragons",
            collectionName: "Night Visions",
            trackName: "Radioactive",
            artistViewURL: "",
            collectionViewURL: "",
            trackViewURL: "",
            previewURL: "",
            artworkUrl30: artwork,
            artworkUrl60: artwork,
            artworkUrl100: artwork,
            collectionPrice: 12.99,
            trackPrice: 1.29,
            releaseDate: "2012-09-04T00:00:00Z",
            trackCount: 11,
            trackNumber: 1,
            trackTimeMillis: 186000,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Rock",
            collectionArtistName: nil
        )
    }

    static func example6() -> Song {
        Song(
            wrapperType: "track",
            artistID: 4,
            collectionID: 4,
            id: 40,
            artistName: "Adele",
            collectionName: "25",
            trackName: "Hello",
            artistViewURL: "",
            collectionViewURL: "",
            trackViewURL: "",
            previewURL: "",
            artworkUrl30: artwork,
            artworkUrl60: artwork,
            artworkUrl100: artwork,
            collectionPrice: 13.99,
            trackPrice: 1.49,
            releaseDate: "2015-10-23T00:00:00Z",
            trackCount: 11,
            trackNumber: 1,
            trackTimeMillis: 295000,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Pop",
            collectionArtistName: nil
        )
    }

    static func example7() -> Song {
        Song(
            wrapperType: "track",
            artistID: 5,
            collectionID: 5,
            id: 50,
            artistName: "Linkin Park",
            collectionName: "Hybrid Theory",
            trackName: "In the End",
            artistViewURL: "",
            collectionViewURL: "",
            trackViewURL: "",
            previewURL: "",
            artworkUrl30: artwork,
            artworkUrl60: artwork,
            artworkUrl100: artwork,
            collectionPrice: 10.99,
            trackPrice: 0.99,
            releaseDate: "2000-10-24T00:00:00Z",
            trackCount: 12,
            trackNumber: 8,
            trackTimeMillis: 216000,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Nu Metal",
            collectionArtistName: nil
        )
    }

    /// Shared artwork to keep previews fast
    private static let artwork =
    "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/08/11/d2/0811d2b3-b4d5-dc22-1107-3625511844b5/00602537869770.rgb.jpg/100x100bb.jpg"
}

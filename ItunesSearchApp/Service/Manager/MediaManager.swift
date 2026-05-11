//
//  MediaManager.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

// https://itunes.apple.com/search?term=jack+johnson&entity=album&limit=5&offset=10
// https://itunes.apple.com/search?term=jack+johnson&entity=song&limit=5
// https://itunes.apple.com/search?term=jack+johnson&entity=movie&limit=5

final class MediaManager {
    private let apiService: APIServiceProtocal
    
    init(apiService: APIServiceProtocal) {
        self.apiService = apiService
    }
    
    func fetchMedia(term: String, type: MediaType, limit: Int = 5, offset: Int = 0) async throws -> AlbumResult {
        let endPoint = ITunesEndpoint.search(
            term: term,
            entity: type.entity,
            limit: limit,
            offset: offset
        )
        
        return try await apiService.request(endpoint: endPoint)
    }
    
    func fetchSongs(term: String, type: MediaType, limit: Int = 5, offset: Int = 0) async throws -> SongResult {
        let endPoint = ITunesEndpoint.search(
            term: term,
            entity: type.entity,
            limit: limit,
            offset: offset
        )
        
        return try await apiService.request(endpoint: endPoint)
    }
    
    func fetchSongs(for albumID: Int, type: MediaType) async throws -> SongResult {
        let endPoint = ITunesEndpoint.lookup(id: albumID, entity: type.entity)
        return try await apiService.request(endpoint: endPoint)
    }
    
    func fetchAlbum(for albumID: Int, type: MediaType)async throws -> AlbumResult  {
        let endPoint = ITunesEndpoint.lookup(id: albumID, entity: type.entity)
        return try await apiService.request(endpoint: endPoint)
    }
    
    func fetchMusicVideos(term: String, type: MediaType, limit: Int = 5, offset: Int = 0) async throws -> MusicVideoResult {
        let endPoint = ITunesEndpoint.search(
            term: term,
            entity: type.entity,
            limit: limit,
            offset: offset
        )
        
        return try await apiService.request(endpoint: endPoint)
    }
}

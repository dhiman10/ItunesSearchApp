//
//  SongsForAlbumListViewModel.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI
import Observation
import Combine

@Observable
@MainActor
class AlbumDetailViewModel {
    
    let albumID: Int
    var songs: [Song] = []
    var state: FetchState = .idle
    private let manager: MediaManager
 
    init(albumID: Int, manager: MediaManager) {
        self.albumID = albumID
        self.manager = manager
    }
    
    func fetchWithId() async {
        guard state != .isLoading else {
            return
        }
        do {
            let result = try await manager.fetchSongs(for: albumID, type: .song)
            songs = result.results.filter{
                $0.wrapperType == "track"
            }
            state = songs.isEmpty ? .noResults : .idle
        }
        catch {
            state = .error(error.localizedDescription)
        }
        
        
    }

    

}

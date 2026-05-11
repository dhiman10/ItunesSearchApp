//
//  SongDetailViewModel.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

@Observable
@MainActor
final class SongDetailViewModel {

    let song: Song

    var album: Album?
    var songs: [Song] = []
    var state: FetchState = .idle

    private let manager: MediaManager

    init(song: Song, manager: MediaManager) {
        self.song = song
        self.manager = manager
    }

    func fetch() async {
        guard state != .isLoading else { return }
        state = .isLoading

        do {
            async let albumResult = manager.fetchAlbum(
                for: song.collectionID,
                type: .album
            )

            async let songResult = manager.fetchSongs(
                for: song.collectionID,
                type: .song
            )

            let (albumResponse, songResponse) = try await (albumResult, songResult)

            album = albumResponse.results.first
            songs = songResponse.results.filter{
                $0.wrapperType == "track"
            }

            state = songs.isEmpty ? .noResults : .idle
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

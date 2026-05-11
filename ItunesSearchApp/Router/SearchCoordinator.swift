//
//  SearchRoute.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

enum SearchRoute: Hashable {
    case song
    case albums
    case musicVideos
    case albumDetail(Album)
    case albumFromSong(Song)
    
}
enum NavigationStyle {
    case push
    case sheet
    case fullScreen
}

enum SearchModal: Identifiable {
    case song
    case albums
    case musicVideos
    case albumDetail(Album)
    case albumFromSong(Song)

    var id: String {
        switch self {
        case .song:
            return "song"
        case .albums:
            return "albums"
        case .musicVideos:
            return "musicVideos"
        case .albumDetail(let album):
            return "album-\(album.id)"
        case .albumFromSong(let song):
            return "song-\(song.id)"
        }
    }
}


@Observable
final class SearchCoordinator {
    var path: [SearchRoute] = []
    
    var sheet: SearchModal?
    var fullScreen: SearchModal?
    
    func navigate(
        to route: SearchRoute,
        style: NavigationStyle = .push
    ) {
        switch style {
        case .push:
            path.append(route)

        case .sheet:
            sheet = modal(from: route)

        case .fullScreen:
            fullScreen = modal(from: route)
        }
    }

    
    // MARK: - Convenience APIs

    func showSongs(style: NavigationStyle = .push) {
        navigate(to: .song, style: style)
    }

    func showAlbums(style: NavigationStyle = .push) {
        navigate(to: .albums, style: style)
    }

    func showMusicVideos(style: NavigationStyle = .push) {
        navigate(to: .musicVideos, style: style)
    }

    func showAlbumDetail(
        _ album: Album,
        style: NavigationStyle = .push
    ) {
        navigate(to: .albumDetail(album), style: style)
    }

    func showAlbumFromSong(
        _ song: Song,
        style: NavigationStyle = .push
    ) {
        navigate(to: .albumFromSong(song), style: style)
    }

    // MARK: - Pop / Dismiss

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func dismissSheet() {
        sheet = nil
    }

    func dismissFullScreen() {
        fullScreen = nil
    }

    func reset() {
        path.removeAll()
        sheet = nil
        fullScreen = nil
    }
    
    private func modal(from route: SearchRoute) -> SearchModal {
        switch route {
        case .song:
            return .song
        case .albums:
            return .albums
        case .musicVideos:
            return .musicVideos
        case .albumDetail(let album):
            return .albumDetail(album)
        case .albumFromSong(let song):
            return .albumFromSong(song)
        }
    }
}

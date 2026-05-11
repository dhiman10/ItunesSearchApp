//
//  SongDetailView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

struct SongDetailView: View {

    @State var viewModel: SongDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let album = viewModel.album {
                AlbumHeaderDetailView(album: album)
            }

            ScrollView {
                content
            }
        }
        .task {
            await viewModel.fetch()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading:
            ProgressView("Loading...")
                .padding()

        case .noResults:
            ContentUnavailableView(
                "No Songs",
                systemImage: "music.note"
            )

        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )

        default:
            SongsGridView(songs: viewModel.songs)
        }
    }
}


#Preview {
    
    let manager = MediaManager(apiService: APIService())
    SongDetailView(
        viewModel: SongDetailViewModel(
            song: Song.example2(),
            manager: manager
        )
    )

}

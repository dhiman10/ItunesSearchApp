//
//  SongListView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

struct SongListView: View {
    let coordinator: SearchCoordinator
    @State var viewModel: SongListViewModel

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading where viewModel.songs.isEmpty:
            ProgressView("Loading...")

        case .noResults:
            ContentUnavailableView(
                "No Results",
                systemImage: "music.note",
                description: Text("No songs found for this search")
            )

        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )

        default:
            songList
        }
    }

    private var songList: some View {
        List {
            ForEach(viewModel.songs) { song in
                Button {
                    coordinator.showAlbumFromSong(song)
                } label: {
                    SongRowView(song: song)
                }
            }

            // Pagination footer
            ListPlaceholderRowView(
                state: viewModel.state,
                loadMore: {
                    Task {
                        await viewModel.loadMore(term: viewModel.searchText)
                    }
                }, hasData: !viewModel.songs.isEmpty
            )
        }
        .listStyle(.plain)
    }
}

#Preview {
    SongListView(
        coordinator: SearchCoordinator(),
        viewModel: SongListViewModel(
            manager: MediaManager(apiService: APIService())
        )
    )
}

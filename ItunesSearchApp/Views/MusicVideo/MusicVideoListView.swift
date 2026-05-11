//
//  MusicVideoListView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//
import SwiftUI

struct MusicVideoListView: View {
    @State var viewModel: MusicVideoListViewModel

    var body: some View {
            content
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading where viewModel.musicVideos.isEmpty:
            ProgressView("Loading...")
        case .noResults:
            ContentUnavailableView(
                "No Results",
                systemImage: "music.note",
                description: Text("No Music Video found for this search")
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
            ForEach(viewModel.musicVideos) { music in
                MusicRowView(music: music)
            }

            // Pagination footer
            ListPlaceholderRowView(
                state: viewModel.state,
                loadMore: {
                    Task {
                        await viewModel.loadMore(term: viewModel.searchText)
                    }
                }, hasData: !viewModel.musicVideos.isEmpty
            )
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MusicVideoListView(viewModel: MusicVideoListViewModel(manager: MediaManager(apiService: APIService())))
    }
}

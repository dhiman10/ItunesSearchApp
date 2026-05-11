//
//  AlbumListView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

struct AlbumListView: View {
    @State var viewModel: AlbumListViewModel
    let coordinator: SearchCoordinator
    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading where viewModel.albums.isEmpty:
            ProgressView("Loading...")
        case .noResults:
            ContentUnavailableView(
                "No Results",
                systemImage: "music.note",
                description: Text("No albums found for this search")
            )
        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        default:
            albumList
        }
    }

    private var albumList: some View {
        List {
            ForEach(viewModel.albums) { album in
                Button {
                    coordinator.showAlbumDetail(album)
                }label: {
                    AlbumRowView(album: album)

                }
                .buttonStyle(.plain)
            }

            // Pagination footer
            ListPlaceholderRowView(
                state: viewModel.state,
                loadMore: {
                    Task {
                        await viewModel.loadMore(term: viewModel.searchText)
                    }
                }, hasData: !viewModel.albums.isEmpty
            )
        }
        .listStyle(.plain)
    }
}

#Preview("With Albums") {
    let vm = AlbumListViewModel(manager: MediaManager(apiService: APIService()))
    vm.albums = Album.mockList
    vm.state = .idle

    return AlbumListView(
        viewModel: vm,
        coordinator: SearchCoordinator()
    )
}

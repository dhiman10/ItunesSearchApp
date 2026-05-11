//
//  SearchView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

struct SearchView: View {
    @State private var selectedEntityType = EntityType.all
    @State private var searchTerm: String = ""

    @State private var albumListViewModel: AlbumListViewModel
    @State private var songViewModel: SongListViewModel
    @State private var musicViewModel: MusicVideoListViewModel

    @State private var coordinator = SearchCoordinator()

    private let manager: MediaManager

    init() {
        let manager = MediaManager(apiService: APIService())
        self.manager = manager
        _albumListViewModel = State(initialValue: AlbumListViewModel(manager: manager))
        _songViewModel = State(
            initialValue: SongListViewModel(manager: manager)
        )
        _musicViewModel = State(
            initialValue: MusicVideoListViewModel(manager: manager)
        )
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                pickerView
                Divider()
                searchPlaceholderView
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .searchable(
                text: $searchTerm)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: searchTerm) { _, newValue in
                applySearch(newValue)
            }
            .onChange(of: selectedEntityType) { _, _ in
                guard !searchTerm.isEmpty else { return }
                applySearch(searchTerm)
            }
            .searchNavigation(
                coordinator: coordinator,
                destination: destination,
                modalDestination: modalDestination
            )
        }
    }

    private func applySearch(_ term: String) {
        switch selectedEntityType {
        case .all:
            albumListViewModel.searchText = term
            songViewModel.searchText = term
            musicViewModel.searchText = term
        case .album:
            albumListViewModel.searchText = term
        case .song:
            songViewModel.searchText = term
        case .musicVideos:
            musicViewModel.searchText = term
        }
    }

    private var pickerView: some View {
        Picker("Select the media", selection: $selectedEntityType) {
            ForEach(EntityType.allCases) { type in
                Text(type.name())
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    @ViewBuilder
    private var searchPlaceholderView: some View {
        if searchTerm.count == 0 {
            SearchPlaceholderView(searchTerm: $searchTerm)
        }
        else {
            switch selectedEntityType {
            case .all:
                SearchAllListView(
                    songs: songViewModel.songs,
                    albums: albumListViewModel.albums,
                    musicVideos: musicViewModel.musicVideos,
                    coordinator: coordinator
                )
            case .album:
                AlbumListView(viewModel: albumListViewModel, coordinator: coordinator)
            case .song:
                SongListView(
                    coordinator: coordinator,
                    viewModel: songViewModel
                )
            case .musicVideos:
                MusicVideoListView(viewModel: musicViewModel)
            }
        }
    }
}

#Preview {
    SearchView()
}

extension SearchView {
    @ViewBuilder
    func destination(for route: SearchRoute) -> some View {
        switch route {
        case .song:
            SongListView(
                coordinator: coordinator,
                viewModel: songViewModel
            )

        case .albums:
            AlbumListView(
                viewModel: albumListViewModel,
                coordinator: coordinator
            )

        case .musicVideos:
            MusicVideoListView(
                viewModel: musicViewModel
            )

        case .albumDetail(let album):
            AlbumDetailView(
                album: album,
                viewModel: AlbumDetailViewModel(
                    albumID: album.id,
                    manager: manager
                )
            )

        case .albumFromSong(let song):
            SongDetailView(
                viewModel: SongDetailViewModel(
                    song: song,
                    manager: manager
                )
            )
        }
    }

    @ViewBuilder
    func modalDestination(
        _ modal: SearchModal,
        coordinator: SearchCoordinator
    ) -> some View {
        switch modal {
        case .song:
            SongListView(
                coordinator: coordinator,
                viewModel: songViewModel
            )

        case .albums:
            AlbumListView(
                viewModel: albumListViewModel,
                coordinator: coordinator
            )

        case .musicVideos:
            MusicVideoListView(viewModel: musicViewModel)

        case .albumDetail(let album):
            AlbumDetailView(
                album: album,
                viewModel: AlbumDetailViewModel(
                    albumID: album.id,
                    manager: manager
                )
            )

        case .albumFromSong(let song):
            SongDetailView(
                viewModel: SongDetailViewModel(
                    song: song,
                    manager: manager
                )
            )
        }
    }

}

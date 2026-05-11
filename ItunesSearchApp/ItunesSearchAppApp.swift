//
//  ItunesSearchAppApp.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 11.12.25.
//

import SwiftUI

@main
struct ItunesSearchAppApp: App {
    var body: some Scene {
        WindowGroup {
           // AlbumListView(viewModel: AlbumListViewModel(manager: MediaManager(apiService: APIService())))
           // SongListView(viewModel: SongListViewModel(manager: MediaManager(apiService: APIService())))
            
            SearchView()

        }
    }
}

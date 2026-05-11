//
//  SearchAllListView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//
import SwiftUI

struct SearchAllListView: View {
    let songs: [Song]
    let albums: [Album]
    let musicVideos: [MusicVideo]
    let coordinator: SearchCoordinator

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                if !songs.isEmpty {
                    SectionHeaderView(
                        title: "Songs",
                        action: {
                            coordinator.showSongs(style: .push)
                        }
                    )
                    SongSectionView(songs: songs, coordinator: coordinator)
                    Divider().padding(.bottom)
                }

                if !albums.isEmpty {
                    SectionHeaderView(
                        title: "Albums",
                        action: {
                            coordinator.showAlbums(style: .push)
                        }
                    )
                    AlbumSectionView(albums: albums,coordinator: coordinator)
                    Divider()
                        .padding(.bottom)
                }

                if !musicVideos.isEmpty {
                    SectionHeaderView(
                        title: "Music Videos",
                        action: {
                            coordinator.showMusicVideos(style: .push)
                        }
                    )
                    MusicSectionView(musicVideos: musicVideos)
                }
            }
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Spacer()
            
            Button(action: action) {
                HStack {
                    Text("See all")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .foregroundStyle(.tint)
            }
        }
        .padding(.horizontal)
    }
}


#Preview("SectionList") {
    SearchAllListView(
        songs: [
            .example(),
            .example2(),
            .example4(),
            .example5()
        ],
        albums: Album.mockList,
        musicVideos: MusicVideo.mockList(),
        coordinator: SearchCoordinator()
    )
}



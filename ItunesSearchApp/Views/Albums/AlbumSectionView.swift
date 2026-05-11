//
//  AlbumSectionView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

struct AlbumSectionView: View {
    let albums: [Album]
    let coordinator: SearchCoordinator

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top) {
                ForEach(albums) { album in
                    Button {
                        coordinator.showAlbumDetail(album, style: .sheet)
                    } label: {
                        AlbumColumnView(album: album)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
        }
    }
}

struct AlbumColumnView: View {
    let album: Album

    var body: some View {
        VStack(alignment: .leading) {
            ImageLoadingView(urlString: album.artworkUrl100, size: 100)
            Text(album.collectionName)
            Text(album.artistName)
                .foregroundColor(Color.gray)
        }
        .lineLimit(2)
        .frame(width: 100)
        .font(.caption)
    }
}

#Preview {
    AlbumSectionView(albums: Album.mockList,
        coordinator: SearchCoordinator()
    )
}

//
//  SongSectionView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

struct SongSectionView: View {
    let songs: [Song]
    let coordinator: SearchCoordinator
    let rows = Array(repeating: GridItem(.fixed(60), spacing: 8, alignment: .leading),
                     count: 4)

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
                ForEach(songs) { song in
                    Button {
                        coordinator.showAlbumFromSong(song, style: .sheet)
                    } label: {
                        SongRowView(song: song)
                            .frame(width: 300)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#Preview {
    SongSectionView(
        songs: [
            .example(),
            .example2(),
            .example4(),
            .example5(),
            .example6()
        ], coordinator: SearchCoordinator()
    )
}

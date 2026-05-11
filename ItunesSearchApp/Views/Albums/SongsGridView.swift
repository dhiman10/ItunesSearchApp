//
//  SongsGridView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//
import SwiftUI

struct SongsGridView: View {
    let songs: [Song]

    var body: some View {
        Grid(horizontalSpacing: 20) {
            ForEach(songs) { song in
                GridRow {
                    Text("\(song.trackNumber)")
                        .font(.footnote)
                        .gridColumnAlignment(.trailing)

                    Text(song.trackName)
                        .lineLimit(2)
                        .gridColumnAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(song.formattedDuration)
                        .font(.footnote)

                    BuySongButton(urlString: song.previewURL,
                                  price: song.trackPrice,
                                  currency: song.currency)
                        .padding(.trailing)
                }
                Divider()
                    .gridCellUnsizedAxes(.horizontal)

            }
        }
        .padding([.bottom, .leading])

    }
}

#Preview {
    SongsGridView(songs: [Song.example(), Song.example2()])
}

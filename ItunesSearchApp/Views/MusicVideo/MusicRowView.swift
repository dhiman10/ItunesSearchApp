//
//  MusicRowView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//


import SwiftUI

struct MusicRowView: View {
    
    let music: MusicVideo
    
    var body: some View {
        HStack {
            
            ImageLoadingView(urlString: music.artworkUrl60,
                             size: 60)
            
            VStack(alignment: .leading) {
                Text(music.trackName)
                Text(music.artistName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .lineLimit(1)
            
            Spacer(minLength: 20)
            
            BuySongButton(urlString: music.artworkUrl100,
                      price: music.trackPrice,
                      currency: music.currency)

        }
    }
}

#Preview {
    MusicRowView(music: .mockMusic())
}

//
//  MovieSectionView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//

import SwiftUI

struct MusicSectionView: View {
    let musicVideos: [MusicVideo]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 8) {
                ForEach(musicVideos) { video in
                    VStack(alignment: .leading) {
                        ImageLoadingView(urlString: video.artworkUrl100, size: 100)
                        
                        Text(video.trackName)
                        Text(video.primaryGenreName)
                            .foregroundColor(Color.gray)
                    }
                    .lineLimit(2)
                    .frame(width: 100)
                    .font(.caption)
                }
            }
            .padding([.horizontal, .bottom])

        }
    }
}

#Preview {
    MusicSectionView(musicVideos: MusicVideo.mockList())
}

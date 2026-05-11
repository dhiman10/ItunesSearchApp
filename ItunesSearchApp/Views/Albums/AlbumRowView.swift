//
//  AlbumRowView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

struct AlbumRowView: View {
    
    let album: Album
    
    var body: some View {
        HStack {
            ImageLoadingView(urlString: album.artworkUrl100, size: 100)
            
            VStack(alignment: .leading) {
                Text(album.collectionName)
                Text(album.artistName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .lineLimit(1)
            
            Spacer(minLength: 20)
            
            BuyButton(urlString: album.collectionViewURL,
                      price: album.collectionPrice,
                      currency: album.currency)
            
        }
    }

}

#Preview {
    AlbumRowView(album: .mockList[0])
}

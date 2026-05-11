//
//  ImageLoadingView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 11.12.25.
//

import SwiftUI

struct ImageLoadingView: View {
    let urlString: String
    let size: CGFloat

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size)
            case .success(let image):
                image
                    .resizable()
                              .scaledToFit()
                              .frame(width: size, height: size)
                              .clipShape(RoundedRectangle(cornerRadius: 8))
                              .overlay(
                                  RoundedRectangle(cornerRadius: 8)
                                      .stroke(Color(white: 0.85))
                              )
            case .failure(_):
                Color.gray
                    .frame(width: size)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: size)
        
    }
}

#Preview {
    ImageLoadingView(urlString: "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/fb/bb/2e/fbbb2e03-6f57-46dd-f7f5-ffd46eb9ab6e/00602498800331.rgb.jpg/60x60bb.jpg", size: 100)
}

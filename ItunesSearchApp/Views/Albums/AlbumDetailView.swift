//
//  AlbumDetailView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 13.12.25.
//
import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    @State var viewModel: AlbumDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            AlbumHeaderDetailView(album: album)
            ScrollView {
                content
            }
        }
        .task {
            await viewModel.fetchWithId()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .isLoading:
            ProgressView("Loading songs...")
                .padding()

        case .noResults:
            ContentUnavailableView(
                "No Songs",
                systemImage: "music.note",
                description: Text("This album has no songs")
            )

        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )

        default:
            SongsGridView(songs: viewModel.songs)
        }
    }
}

#Preview {
    AlbumDetailView(
        album: Album.mockList[0],
        viewModel: AlbumDetailViewModel(
            albumID: Album.mockList[0].id,
            manager: MediaManager(apiService: APIService())
        )
    )
}

struct AlbumHeaderDetailView: View {
    let album: Album

    var body: some View {
        HStack(alignment: .bottom) {
            ImageLoadingView(urlString: album.artworkUrl100, size: 100)
            VStack(alignment: .leading) {
                Text(album.collectionName)
                    .font(.footnote)
                    .foregroundColor(Color(.label))
                Text(album.artistName)
                    .padding(.bottom, 5)
                Text(album.primaryGenreName)
                Text("\(album.trackCount) songs")
                Text("Released: \(album.formattedDate())")
            }
            .font(.caption)
            .foregroundColor(.gray)
            .lineLimit(1)

            Spacer(minLength: 20)

            BuyButton(urlString: album.collectionViewURL,
                      price: album.collectionPrice,
                      currency: album.currency)
        }
        .padding()
        .background(
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.top)
                .shadow(radius: 5)
        )
    }
}

#Preview("AlbumHeaderDetailView") {
    AlbumHeaderDetailView(album: Album.mockList[0])
}

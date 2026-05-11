//
//  ListPlaceholderRowView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 11.12.25.
//
import SwiftUI

struct ListPlaceholderRowView: View {
    let state: FetchState
    let loadMore: () -> Void
    let hasData: Bool

    var body: some View {
        switch state {
        case .idle:
            if hasData {
                Color.clear
                    .onAppear { loadMore() }
            }
        case .isLoading:
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity)
        case .loadedAll:
            EmptyView()
        case .noResults:
            Text("Sorry Could not find anything.")
                .foregroundColor(.gray)
        case .error(let message):
            Text(message)
                .foregroundColor(.pink)
        }
    }
}

#Preview {
    ListPlaceholderRowView(state: .noResults, loadMore: {}, hasData: false)
}

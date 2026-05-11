//
//  SearchPlaceholderView.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 11.12.25.
//
import SwiftUI

struct SearchPlaceholderView: View {
    
    @Binding var searchTerm: String
    let suggestions = ["rammstein", "cry to me", "maneskin"]

    var body: some View {
        
        Text("Trending")
            .font(.title)
        ForEach(suggestions, id: \.self) { text in
            Button {
                searchTerm = text
            }label: {
                Text(text)
                    .font(.title2)
            }
            
        }
        
    }
    
    
}

#Preview {
    SearchPlaceholderView(searchTerm: .constant("rammstein"))
}

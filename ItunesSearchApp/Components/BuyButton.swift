//
//  BuyButton.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI

struct BuySongButton: View {
    
    let urlString: String
    let price: Double?
    let currency: String
    
    var body: some View {
        if let price = price {
            BuyButton(urlString: urlString,
                      price: price,
                      currency: currency)
        } else {
            Text("ALBUM ONLY")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

#Preview("BuySongButton") {
    BuySongButton(
        urlString: "https://music.apple.com/us/album/in-between-dreams/1440768692",
        price: 9.99,
        currency: "USD"
    )
    .padding()
}

struct BuyButton: View {
    let urlString: String
    let price: Double?
    let currency: String
    
    var body: some View {
        if let url =  URL(string: urlString),
            let priceText = formattedPrice() {
            Link(destination: url) {
                Text(priceText)
            }
            .buttonStyle(BuyButtonStyle())
        }
    }
    
    func formattedPrice() -> String? {
        
        guard let price = price else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        
        let priceString = formatter.string(from: NSNumber(value: price))
        return priceString
    }
}

#Preview {
    BuyButton(
        urlString: "https://music.apple.com/us/album/in-between-dreams/1440768692",
        price: 9.99,
        currency: "USD"
    )
    .padding()
}

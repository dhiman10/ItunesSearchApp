//
//  FetchState.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 11.12.25.
//


import Foundation

enum FetchState: Comparable {
    case idle
    case isLoading
    case loadedAll
    case noResults
    case error(String)
}

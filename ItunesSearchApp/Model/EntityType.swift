//
//  EntityType.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

enum EntityType: String, Identifiable, CaseIterable {
    
    case all
    case album
    case song
    case musicVideos
    
    var id: String {
        self.rawValue
    }
    
    func name () -> String {
        switch self {
        case .all:
            return "All"
        case .album:
            return "Albums"
        case .song:
            return "Songs"
        case .musicVideos:
            return "Music Videos"
        }
    }
    
}

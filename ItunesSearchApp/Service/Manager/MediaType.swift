//
//  MediaType.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import Foundation

enum MediaType {
    case album
    case song
    case musicVideo
    
    var entity: String {
        switch self {
        case .album:
            return "album"
        case .song:
            return "song"
        case .musicVideo:
            return "musicVideo"
        }
    }
}


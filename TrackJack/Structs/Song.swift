//
//  Song.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 9/17/25.
//

import Foundation

struct Song: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var artist: String
    var spotifyURL: URL? = nil
}

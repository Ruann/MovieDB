//
//  MovieCategoy.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

enum MovieCategory: String,  CaseIterable {
    case NowPlaying = "now_playing"
    case Popular = "popular"
    case TopRated = "top_rated"
    case Upcoming = "upcoming"
    
    var displayName: String {
        switch self {
            case .NowPlaying:
                return "Now Playing"
            case .Popular:
                return "Popular"
            case .TopRated:
                return "Top Rated"
            case .Upcoming:
                return "Upcoming"
        }
    }
}

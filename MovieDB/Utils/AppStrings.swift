//
//  AppStrings.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct AppStrings {
    struct MovieCategory {
        static let nowPlaying = NSLocalizedString("NowPlaying", comment: "")
        static let popular = NSLocalizedString("Popular", comment: "")
        static let topRated = NSLocalizedString("TopRated", comment: "")
        static let upcoming = NSLocalizedString("Upcoming", comment: "")
        static let searchResults = NSLocalizedString("SearchResults", comment: "")
    }
    
    struct Home {
        static let searchHeader = NSLocalizedString("SearchHeader", comment: "")
    }
    
    struct MovieDetail {
        static let studios = NSLocalizedString("Studios", comment: "")
        static let genre = NSLocalizedString("Genre", comment: "")
        static let release = NSLocalizedString("Release", comment: "")
    }
}

//
//  AppStrings.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct AppStrings {
    
    struct Global {
        static let ok = NSLocalizedString("OK", comment: "")
    }
    
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
        static let missingSummary = NSLocalizedString("MissingSummary", comment: "")
        static let notInformed = NSLocalizedString("NotInformed", comment: "")
    }
    
    struct Network {
        static let alertTitle = NSLocalizedString("NetworkAlertTitle", comment: "")
        static let alertMessage = NSLocalizedString("NetworkAlertMessage", comment: "")
    }
    
    struct MovieCell {
        static let noPosterAvailable = NSLocalizedString("NoPosterAvailable", comment: "")
    }
    
    struct Error {
        static let movieRequestErrorMessage = NSLocalizedString("MovieRequestErrorMessage", comment: "")
    }
}

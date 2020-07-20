//
//  MovieCategoy.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

enum MovieCategory: String,  CaseIterable {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    case search
    
    var displayName: String {
        switch self {
            case .nowPlaying:
                return AppStrings.MovieCategory.nowPlaying
            case .popular:
                return AppStrings.MovieCategory.popular
            case .topRated:
                return AppStrings.MovieCategory.topRated
            case .upcoming:
                return AppStrings.MovieCategory.upcoming
            case .search:
                return AppStrings.MovieCategory.searchResults
        }
    }
    
    static var allCategories: [MovieCategory] {
        MovieCategory.allCases.filter({ $0 != .search })
    }
}

//
//  MovieListCategory.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

enum MovieListCategory: CaseIterable {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    case search
    
    var displayName: String {
        switch self {
            case .nowPlaying:
                return AppStrings.MovieCategory.nowPlaying
            case .popular:
                return AppStrings.MovieCategory.popular
            case .search:
                return AppStrings.MovieCategory.searchResults
            case .topRated:
                return AppStrings.MovieCategory.topRated
            case .upcoming:
                return AppStrings.MovieCategory.upcoming
        }
    }
    
    static var allCategories: [MovieListCategory] {
        MovieListCategory.allCases.filter{ $0 != .search }
    }
}

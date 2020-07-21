//
//  Movie.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation
import UIKit

struct Movie: Codable {
    let title: String
    let overview: String
    let backgroundImagePath: String?
    let genres: [MovieGenre]
    let studios: [ProductionCompany]
    let releaseDate: String
    let voteAverage: Double?
    
    var backgroundImageFullPath: String {
        guard let configuration = Configuration.shared,
            let backgroundImagePath = backgroundImagePath else {
                return String.empty
        }
        
        return configuration.backgroundImageBaseUrl+backgroundImagePath
    }
    
    var genreList: String {
        genres.map({ $0.name }).joined(separator: String.separatorForList)
    }
    
    var studioList: String {
        studios.map({ $0.name }).joined(separator: String.separatorForList)
    }
    
    var yearReleased: String? {
        DateHelper.shared.getYearFrom(string: releaseDate)
    }
    
    private enum CodingKeys : String, CodingKey {
        case title
        case overview
        case backgroundImagePath = "backdrop_path"
        case genres
        case studios = "production_companies"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

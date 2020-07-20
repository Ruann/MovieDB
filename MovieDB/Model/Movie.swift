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
            return ""
        }
        
        let baseUrl = configuration.images.baseUrl
        let posterSize = configuration.images.backdropsizes.first ?? ""
        
        return "\(baseUrl)\(posterSize)\(backgroundImagePath)"
    }
    
    var genreList: String {
        genres.map({ $0.name }).joined(separator: ", ")
    }
    
    var studioList: String {
        studios.map({ $0.name }).joined(separator: ", ")
    }
    
    var yearReleased: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from:releaseDate) else {
            return nil
        }

        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date)
        return "\(components.year ?? 0)"
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

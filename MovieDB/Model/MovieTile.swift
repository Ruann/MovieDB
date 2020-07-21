//
//  Movie.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation
import UIKit

struct MovieTile: Codable {
    let movieId: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double?
    
    var fullPosterPath: String {
        guard let configuration = Configuration.shared,
            let posterPath = posterPath else {
                return String.empty
        }
        
        return configuration.posterBaseUrl+posterPath
    }
    
    private enum CodingKeys : String, CodingKey {
        case movieId = "id"
        case title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}

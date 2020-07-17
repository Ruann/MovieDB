//
//  Movie.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let posterPath: String
    
    private enum CodingKeys : String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}

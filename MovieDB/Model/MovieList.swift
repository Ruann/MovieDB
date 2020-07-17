//
//  MovieList.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let movies: [Movie]
    
    private enum CodingKeys : String, CodingKey {
        case movies = "results"
    }
}

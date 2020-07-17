//
//  Configuration.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct Configuration: Codable {
    let images: ImagesConfiguration
}

struct ImagesConfiguration: Codable {
    let baseUrl: String
    let posterSizes: [String]
    
    private enum CodingKeys : String, CodingKey {
        case baseUrl = "secure_base_url"
        case posterSizes = "poster_sizes"
    }
}

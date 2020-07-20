//
//  Configuration.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct Configuration: Codable {
    static var shared: Configuration?
    
    let images: ImagesConfiguration
    
    var posterBaseUrl: String {
        let baseUrl = images.baseUrl
        let posterSize = images.posterSizes.first ?? String.empty
        
        return baseUrl+posterSize
    }
    
    var backgroundImageBaseUrl: String {
        let baseUrl = images.baseUrl
        let backgroundImageSize = images.backdropsizes.first ?? String.empty
        
        return baseUrl+backgroundImageSize
    }
}

struct ImagesConfiguration: Codable {
    let baseUrl: String
    let backdropsizes: [String]
    let posterSizes: [String]
    
    private enum CodingKeys : String, CodingKey {
        case baseUrl = "secure_base_url"
        case posterSizes = "poster_sizes"
        case backdropsizes  = "backdrop_sizes"
    }
}

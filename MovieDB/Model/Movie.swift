//
//  Movie.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation
import UIKit

struct Movie: Codable {
    let title: String
    let posterPath: String
    
    var fullPosterPath: String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let configuration = appDelegate.configuration else {
            return ""
        }
        
        let baseUrl = configuration.images.baseUrl
        let posterSize = configuration.images.posterSizes.first ?? ""
        
        return "\(baseUrl)\(posterSize)\(posterPath)"
    }
    
    private enum CodingKeys : String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}

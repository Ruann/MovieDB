//
//  MovieDBApiConfiguration.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct MovieDBApiParametersKey {
    static let apiKey = "api_key"
    static let page = "page"
    static let query = "query"
}

struct MovieDBApiConfiguration {
    private static let baseUrl = "https://api.themoviedb.org/3"
    
    static let configurationUrl = "\(baseUrl)/configuration"
    
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist.object(forKey: "Api Key") as? String else {
                  return String.empty
          }

        return apiKey
    }
    
    static func categoryUrl(for category: MovieListCategory) -> String {
        switch category {
            case .nowPlaying:
                return "\(baseUrl)/movie/now_playing"
            case .popular:
                return "\(baseUrl)/movie/popular"
            case .topRated:
                return "\(baseUrl)/movie/top_rated"
            case .upcoming:
                return "\(baseUrl)/movie/upcoming"
            case .search:
                return "\(baseUrl)/search/movie"
        }
    }
    
    static func movieDetailUrl(movieId: Int) -> String {
        "\(baseUrl)/movie/\(movieId)"
    }
}

//
//  MovieList.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let page: Int
    let total: Int
    let moviesTile: [MovieTile]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case total = "total_results"
        case moviesTile = "results"
    }
    
    func merge(newMovieList: MovieList) -> MovieList {
        let newMoviesArray = moviesTile + newMovieList.moviesTile
        let newPage = max(page, newMovieList.page)
        let newTotal = max(total, newMovieList.total)
        return MovieList(page: newPage, total: newTotal, moviesTile: newMoviesArray)
    }
}

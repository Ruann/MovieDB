//
//  MovieService.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

class MovieService {
    
    public func requestMovies(completion: @escaping (Result<MovieList, Error>) -> Void) {
        let movieApi = MovieDBApi()
        movieApi.requestMovies(completion: completion)
    }
}

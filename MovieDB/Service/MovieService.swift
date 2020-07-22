//
//  MovieService.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

final class MovieService {
    static let shared = MovieService()
    private let movieApi = MovieDBApi()
    
    private init() {}
    
    func requestConfiguration(completion: @escaping (Result<Configuration, Error>) -> Void) {
        movieApi.requestConfiguration(completion: completion)
    }
    
    func requestMovies(from category: MovieListCategory, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) {
        movieApi.requestMovies(from: category, page: page, completion: completion)
    }
    
    func requestMovies(searchCriteria: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) {
        movieApi.requestMovies(searchCriteria: searchCriteria, page: page, completion: completion)
    }
    
    func requestMoviesDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        movieApi.requestMoviesDetails(movieId: movieId, completion: completion)
    }
}

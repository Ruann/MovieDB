//
//  MovieDBApi.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case missingData
}

class MovieDBApi {
    var latestSearchRequest: URLSessionDataTask?
    var latestSearchTerm: String?
    
    func requestConfiguration(completion: @escaping (Result<Configuration, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/configuration?api_key=4fbdbdb7ab0a64a4ff94f65a19d7693a"
        requestData(url: urlString, completion: completion)
    }
    
    func requestMovies(from category: MovieCategory, page: Int,completion: @escaping (Result<MovieList, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(category.rawValue)?page=\(page)&api_key=4fbdbdb7ab0a64a4ff94f65a19d7693a"
        requestData(url: urlString, completion: completion)
    }
    
    func requestMoviesDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=4fbdbdb7ab0a64a4ff94f65a19d7693a"
        requestData(url: urlString, completion: completion)
    }
    
    func requestMovies(searchCriteria: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(searchCriteria)&page=\(page)&api_key=4fbdbdb7ab0a64a4ff94f65a19d7693a"
        
        if searchCriteria != latestSearchTerm {
            latestSearchRequest?.cancel()
            latestSearchTerm = searchCriteria
        }
        print(urlString)
        latestSearchRequest = requestData(url: urlString, completion: completion)
    }
    
    @discardableResult
    private func requestData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        
        guard let url = URL(string: url) else {
            return nil
        }
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(Result.failure(error!))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(Result.failure(NetworkError.missingData))
                }
                return
            }
            
            
            do {
                let decodeObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(decodeObject))
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        })
        
        task.resume()
        return task
    }
}

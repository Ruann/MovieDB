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
    case searchEmptyString
}

class MovieDBApi {
    var latestSearchRequest: URLSessionDataTask?
    var latestSearchTerm: String?
    
    func requestConfiguration(completion: @escaping (Result<Configuration, Error>) -> Void) {
        let parameters = [
            URLQueryItem(name: MovieDBApiParametersKey.apiKey, value: MovieDBApiConfiguration.apiKey)
        ]
        
        requestData(urlString: MovieDBApiConfiguration.configurationUrl, parameters: parameters, completion: completion)
    }
    
    func requestMovies(from category: MovieCategory, page: Int,completion: @escaping (Result<MovieList, Error>) -> Void) {
        let parameters = [
            URLQueryItem(name: MovieDBApiParametersKey.page, value: "\(page)"),
            URLQueryItem(name: MovieDBApiParametersKey.apiKey, value: MovieDBApiConfiguration.apiKey)
        ]
        
        let url = MovieDBApiConfiguration.categoryUrl(for: category)
        requestData(urlString: url, parameters: parameters, completion: completion)
    }
    
    func requestMoviesDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let parameters = [
            URLQueryItem(name: MovieDBApiParametersKey.apiKey, value: MovieDBApiConfiguration.apiKey)
        ]
        
        let url = MovieDBApiConfiguration.movieDetailUrl(movieId: movieId)
        requestData(urlString: url, parameters: parameters, completion: completion)
    }
    
    func requestMovies(searchCriteria: String, page: Int, completion: @escaping (Result<MovieList, Error>) -> Void) {
        
        guard !searchCriteria.isEmpty else  {
            completion(Result.failure(NetworkError.searchEmptyString))
            return
        }
        
        let parameters = [
            URLQueryItem(name: MovieDBApiParametersKey.query, value: searchCriteria),
            URLQueryItem(name: MovieDBApiParametersKey.page, value: "\(page)"),
            URLQueryItem(name: MovieDBApiParametersKey.apiKey, value: MovieDBApiConfiguration.apiKey)
        ]
        
        let url = MovieDBApiConfiguration.categoryUrl(for: .search)
        
        if searchCriteria != latestSearchTerm {
            latestSearchRequest?.cancel()
            latestSearchTerm = searchCriteria
        }
        
        latestSearchRequest = requestData(urlString: url, parameters: parameters, completion: completion)
    }
    
    @discardableResult
    private func requestData<T: Decodable>(urlString: String, parameters: [URLQueryItem], completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = parameters
        
        guard let url = urlComponents?.url else {
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

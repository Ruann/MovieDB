//
//  MovieCategoryProvider.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

protocol MovieCategoryProviderDelegate {
    func onRequestCompleted(with newIndexPathsToReload: [IndexPath]?, movieCategoryProvider: MovieCategoryProvider)
}

class MovieCategoryProvider {
    
    var delegate: MovieCategoryProviderDelegate?
    
    private var movieList: MovieList?
    private var movieCategory: MovieCategory

    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var displayName: String {
        return movieCategory.displayName
    }
    
    var totalMoviesLoaded: Int {
        return movieList?.movies.count ?? 0
    }
    
    var totalMoviesToDisplay: Int {
        guard movieList != nil else { return 0 }
        return total
    }
    
    init(movieCategory: MovieCategory) {
        self.movieCategory = movieCategory
    }
    
    func requestMovies() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        MovieService.shared.requestMovies(from: movieCategory, page: currentPage) { result in
            switch result {
            case .success(let movieList):
                self.isFetchInProgress = false
                self.currentPage += 1
                self.total = movieList.total
                
                self.loadNewMovies(newMovieList: movieList)
            case .failure(let error):
                self.isFetchInProgress = false
                print(error.localizedDescription)
            }
        }
    }
    
    func movie(for indexPath: IndexPath) -> Movie? {
        movieList?.movies[indexPath.row]
    }
    
    func isLoadingMovieCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= totalMoviesLoaded
    }
    
    private func loadNewMovies(newMovieList: MovieList) {
        if newMovieList.page > 1 {
            movieList = movieList?.merge(newMovieList: newMovieList)
            let indexPathsToReload = self.calculateIndexPathsToReload(from: newMovieList.movies)
            self.delegate?.onRequestCompleted(with: indexPathsToReload, movieCategoryProvider: self)
        } else {
            movieList = newMovieList
            self.delegate?.onRequestCompleted(with: .none, movieCategoryProvider: self)
        }
    }
    
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = totalMoviesLoaded - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

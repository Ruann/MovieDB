//
//  MovieListProvider.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

protocol MovieListProviderDelegate {
    func onRequestCompleted(with newIndexPathsToReload: [IndexPath]?, movieCategoryProvider: MovieListProvider)
    func onRequestFailed(with error: Error, movieCategoryProvider: MovieListProvider)
}

class MovieListProvider {
    
    var delegate: MovieListProviderDelegate?
    var movieCategory: MovieCategory
    
    private var movieList: MovieList?
    private var searchTerm: String?

    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var displayName: String {
        return movieCategory.displayName
    }
    
    var totalMoviesLoaded: Int {
        return movieList?.moviesTile.count ?? 0
    }
    
    var totalMoviesToDisplay: Int {
        guard movieList != nil else { return 0 }
        return total
    }
    
    init(movieCategory: MovieCategory) {
        self.movieCategory = movieCategory
    }
    
    init(searchText: String) {
        self.movieCategory = .search
        self.searchTerm = searchText
    }
    
    func requestMovies() {
        switch movieCategory {
            case .search:
                requestMatechedMovies()
            default:
                requestMoviesFromCategory()
        }
    }
    
    func requestMoviesFromCategory() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        MovieService.shared.requestMovies(from: movieCategory, page: currentPage) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let movieList):
                self.isFetchInProgress = false
                self.currentPage += 1
                self.total = movieList.total
                
                self.loadNewMovies(newMovieList: movieList)
            case .failure(let error):
                if self.currentPage == 1 {
                    self.delegate?.onRequestFailed(with: error, movieCategoryProvider: self)
                }
                self.isFetchInProgress = false
                print(error.localizedDescription)
            }
        }
    }
    
    func requestMatechedMovies() {
        guard !isFetchInProgress else { return }
        
        guard let searchTerm = searchTerm else { return }
        isFetchInProgress = true
        
        MovieService.shared.requestMovies(searchCriteria: searchTerm, page: currentPage) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let movieList):
                self.isFetchInProgress = false
                self.currentPage += 1
                self.total = movieList.total
                
                self.loadNewMovies(newMovieList: movieList)
            case .failure(let error):
                if self.currentPage == 1 {
                    self.delegate?.onRequestFailed(with: error, movieCategoryProvider: self)
                }
                self.isFetchInProgress = false
                print(error.localizedDescription)
            }
        }
    }
    
    func movieTile(for indexPath: IndexPath) -> MovieTile? {
        guard indexPath.row < movieList?.moviesTile.count ?? 0 else { return nil }
        return movieList?.moviesTile[indexPath.row]
    }
    
    func isLoadingMovieCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= totalMoviesLoaded
    }
    
    private func loadNewMovies(newMovieList: MovieList) {
        if newMovieList.page > 1 {
            movieList = movieList?.merge(newMovieList: newMovieList)
            let indexPathsToReload = self.calculateIndexPathsToReload(from: newMovieList.moviesTile)
            self.delegate?.onRequestCompleted(with: indexPathsToReload, movieCategoryProvider: self)
        } else {
            movieList = newMovieList
            self.delegate?.onRequestCompleted(with: .none, movieCategoryProvider: self)
        }
    }
    
    private func calculateIndexPathsToReload(from newMoviesTiles: [MovieTile]) -> [IndexPath] {
        let startIndex = totalMoviesLoaded - newMoviesTiles.count
        let endIndex = startIndex + newMoviesTiles.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

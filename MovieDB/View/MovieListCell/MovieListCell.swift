//
//  MovieListCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

//MARK: - MovieListCellDelegate

protocol MovieListCellDelegate {
    func didSelect(movieTile: MovieTile, movieListCell: MovieListCell)
}

//MARK: - MovieListCell

final class MovieListCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var movieCollection: UICollectionView! {
        didSet {
            movieCollection.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.identifier)
            movieCollection.dataSource = self
            movieCollection.delegate = self
            movieCollection.prefetchDataSource = self
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = cellLineSpacing
            movieCollection.collectionViewLayout = layout
        }
    }
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.text = AppStrings.Error.movieRequestErrorMessage
        }
    }
    @IBOutlet weak var collectionActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    static var nib = UINib(nibName: "MovieListCell", bundle: nil)
    static let identifier = "MovieListCell"
    
    var delegate: MovieListCellDelegate?
    
    private var movieCategoryProvider: MovieListProvider?
    
    //MARK: - Constant
    
    let cellLineSpacing: CGFloat = 20.0
    let cellSize = CGSize(width: 150, height: 230)
    let collectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    
    //MARK: - Life Cycle
    
    func prepare(movieCategoryProvider: MovieListProvider) {
        self.movieCategoryProvider = movieCategoryProvider
        movieCategoryProvider.delegate = self
        
        categoryLabel.text = movieCategoryProvider.displayName.uppercased()
        
        movieCategoryProvider.requestMovies()
    }
    
    override func prepareForReuse() {
        movieCategoryProvider = nil
        categoryLabel.text = nil
        movieCollection.reloadData()
        statusLabel.text = AppStrings.Error.movieRequestErrorMessage
        statusLabel.isHidden = true
        collectionActivityIndicator.isHidden = false
    }
    
    //MARK: - Private Methods
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = movieCollection.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

//MARK: - Collection View Delegates

extension MovieListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieCategoryProvider?.totalMoviesToDisplay ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        guard let movieCategoryProvider = movieCategoryProvider else {
            return UICollectionViewCell()
        }
        
        guard !movieCategoryProvider.isLoadingMovieCell(for: indexPath),
            let movieTile = movieCategoryProvider.movieTile(for: indexPath) else {
                movieCell.prepareWithDefaultValues()
                return movieCell
        }
        
        let voteAverage = movieTile.voteAverage ?? 0.0
        movieCell.prepare(title: movieTile.title, posterUrl: movieTile.fullPosterPath, voteAverage: voteAverage)
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieCategoryProvider = movieCategoryProvider else { return }
        guard let selectedMovie = movieCategoryProvider.movieTile(for: indexPath) else { return }
        
        delegate?.didSelect(movieTile: selectedMovie, movieListCell: self)
    }
}

//MARK: - Collection View Prefetch Delegate

extension MovieListCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let movieCategoryProvider = movieCategoryProvider else { return }
        if indexPaths.contains(where: movieCategoryProvider.isLoadingMovieCell) {
            movieCategoryProvider.requestMovies()
        }
    }
}


//MARK: - Collection View Layout Delegate

extension MovieListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        collectionInset
    }
}

//MARK: - Provider Delegate

extension MovieListCell: MovieListProviderDelegate {
    func onRequestCompleted(with newIndexPathsToReload: [IndexPath]?, movieCategoryProvider: MovieListProvider) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            
            if movieCategoryProvider.movieCategory == .search && movieCategoryProvider.totalMoviesLoaded == 0 {
                statusLabel.text = AppStrings.MovieCategory.noResults
                statusLabel.isHidden = false
            } else {
                statusLabel.isHidden = true
            }
            
            collectionActivityIndicator.stopAnimating()
            movieCollection.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        
        movieCollection.reloadItems(at: indexPathsToReload)
    }
    
    func onRequestFailed(with error: Error, movieCategoryProvider: MovieListProvider) {
        if let networkError = error as? NetworkError,
            networkError == NetworkError.searchEmptyString {
            statusLabel.text = AppStrings.MovieCategory.noResults
        }
        
        collectionActivityIndicator.stopAnimating()
        statusLabel.isHidden = false
    }
}

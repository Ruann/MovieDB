//
//  MovieListCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

protocol MovieListCellDelegate {
    func didSelect(movieTile: MovieTile, movieListCell: MovieListCell)
}

class MovieListCell: UICollectionViewCell {
    var delegate: MovieListCellDelegate?
    
    private var movieCategoryProvider: MovieCategoryProvider?
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var movieCollection: UICollectionView! {
        didSet {
            movieCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
            movieCollection.dataSource = self
            movieCollection.delegate = self
            movieCollection.prefetchDataSource = self
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 20.0
            movieCollection.collectionViewLayout = layout
        }
    }
    
    func prepare(movieCategoryProvider: MovieCategoryProvider) {
        self.movieCategoryProvider = movieCategoryProvider
        movieCategoryProvider.delegate = self
        
        self.categoryLabel.text = movieCategoryProvider.displayName
        
        movieCategoryProvider.requestMovies()
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = movieCollection.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    override func prepareForReuse() {
        movieCategoryProvider = nil
        categoryLabel.text = nil
    }
}

extension MovieListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieCategoryProvider = movieCategoryProvider else { return 0 }
        return movieCategoryProvider.totalMoviesToDisplay
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        guard let movieCategoryProvider = movieCategoryProvider else {
            return UICollectionViewCell()
        }
        
        guard !movieCategoryProvider.isLoadingMovieCell(for: indexPath),
            let movieTile = movieCategoryProvider.movieTile(for: indexPath) else {
                return movieCell
        }
        
        movieCell.prepare(title: movieTile.title, posterUrl: movieTile.fullPosterPath)
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieCategoryProvider = movieCategoryProvider else { return }
        guard let selectedMovie = movieCategoryProvider.movieTile(for: indexPath) else { return }
        
        delegate?.didSelect(movieTile: selectedMovie, movieListCell: self)
    }
}

extension MovieListCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let movieCategoryProvider = movieCategoryProvider else { return }
        if indexPaths.contains(where: movieCategoryProvider.isLoadingMovieCell) {
            movieCategoryProvider.requestMovies()
        }
    }
}


extension MovieListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    }
}

extension MovieListCell: MovieCategoryProviderDelegate {
    func onRequestCompleted(with newIndexPathsToReload: [IndexPath]?, movieCategoryProvider: MovieCategoryProvider) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            movieCollection.reloadData()
            return
        }
      
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        
        movieCollection.reloadItems(at: indexPathsToReload)
    }
}

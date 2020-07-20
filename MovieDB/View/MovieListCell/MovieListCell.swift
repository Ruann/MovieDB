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

class MovieListCell: UICollectionViewCell {
    
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
    
    //MARK: - Properties
    
    static var nib = UINib(nibName: "MovieListCell", bundle: nil)
    static var identifier = "MovieListCell"
    
    var delegate: MovieListCellDelegate?
    
    private var movieCategoryProvider: MovieCategoryProvider?
    
    //MARK: - Constante
    let cellLineSpacing: CGFloat = 20.0
    let cellSize = CGSize(width: 150, height: 230)
    let collectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
    
    //MARK: - Life Cycle
    
    func prepare(movieCategoryProvider: MovieCategoryProvider) {
        self.movieCategoryProvider = movieCategoryProvider
        movieCategoryProvider.delegate = self
        
        self.categoryLabel.text = movieCategoryProvider.displayName.uppercased()
        
        movieCategoryProvider.requestMovies()
    }
    
    override func prepareForReuse() {
        movieCategoryProvider = nil
        categoryLabel.text = nil
        movieCollection.reloadData()
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
        guard let movieCategoryProvider = movieCategoryProvider else { return 0 }
        return movieCategoryProvider.totalMoviesToDisplay
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

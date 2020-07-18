//
//  MovieListCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    private var movieList: MovieList?
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var movieCollection: UICollectionView! {
        didSet {
            movieCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
            movieCollection.dataSource = self
            movieCollection.delegate = self
        }
    }
    
    func prepare(movieCategory: MovieCategory) {
        self.categoryLabel.text = movieCategory.displayName
        
        MovieService.shared.requestMovies(from: movieCategory) { result in
            switch result {
            case .success(let movieList):
                self.movieList = movieList
                self.movieCollection.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MovieListCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieList = movieList else { return 0 }
        return movieList.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell,
            let movie = movieList?.movies[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        movieCell.prepare(title: movie.title, posterUrl: movie.fullPosterPath)
        
        return movieCell
    }
}

extension MovieListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 280)
    }
}

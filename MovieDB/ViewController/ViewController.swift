//
//  ViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var movieCollection: UICollectionView!
    private var movieList: MovieList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollection.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        movieCollection.dataSource = self
        movieCollection.delegate = self
        
        
        let bla = MovieService()
        bla.requestMovies { result in
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieList = movieList else { return 0 }
        return movieList.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell,
            let movie = movieList?.movies[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        movieCell.prepare(title: movie.title, posterUrl: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)")
        
        return movieCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}

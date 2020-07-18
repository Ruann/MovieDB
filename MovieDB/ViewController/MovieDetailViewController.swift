//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private var movieTile: MovieTile?
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDetailTextView: UITextView!
    @IBOutlet weak var studioListLabel: UILabel!
    @IBOutlet weak var genreListLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMovieDetails()
    }
    
    func load(_ movie: MovieTile) {
        self.movieTile = movie
    }
    
    private func requestMovieDetails() {
        guard let movieTile = movieTile else { return }
        MovieService.shared.requestMoviesDetails(movieId: movieTile.movieId) { result in
            switch result {
            case .success(let movie):
                self.loadDetails(movie: movie)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadDetails(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDetailTextView.text = movie.overview
        studioListLabel.text = movie.studioList
        genreListLabel.text = movie.genreList
        releaseDateLabel.text = movie.releaseDate
        
        loadBackgroundImage(url: movie.backgroundImageFullPath)
    }
    
    
    private func loadBackgroundImage(url: String) {
        ImageDownloader.shared.getImage(url: url) { result in
            switch result {
            case .success(let image):
                self.movieBackgroundImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

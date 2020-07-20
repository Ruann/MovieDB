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
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView! {
        didSet {
            movieBackgroundImageView.layer.roundCorners(cornerMasks: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 15.0)
        }
    }
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDetailLabel: UILabel!
    @IBOutlet weak var studioListLabel: UILabel!
    @IBOutlet weak var genreListLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMovieDetails()
    }
    
    func load(_ movie: MovieTile) {
        self.movieTile = movie
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        movieDetailLabel.text = !movie.overview .isEmpty ? movie.overview : "None summary provide"
        studioListLabel.text = !movie.studioList.isEmpty ? movie.studioList : "Not Informed"
        genreListLabel.text = !movie.genreList.isEmpty ? movie.genreList : "Not Informed"
        releaseDateLabel.text = movie.yearReleased
        
        loadBackgroundImage(urlString: movie.backgroundImageFullPath)
        starRatingView.setupStars(voteAverage: movie.voteAverage ?? 0)
    }
    
    private func loadBackgroundImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
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

//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

//MARK: - MovieDetailViewController

class MovieDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView! {
        didSet {
            movieBackgroundImageView.layer.roundCorners(cornerMasks: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: backgroundImageRadius)
        }
    }
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDetailLabel: UILabel!
    @IBOutlet weak var studioListLabel: UILabel!
    @IBOutlet weak var genreListLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    //MARK: - Properties
    
    static var identifier = "MovieDetailViewController"
    
    private var movieTile: MovieTile?
    
    //MARK: - Constants
    
    let backgroundImageRadius: CGFloat = 15.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMovieDetails()
    }
    
    //MARK: - Public methods
    
    func load(_ movie: MovieTile) {
        self.movieTile = movie
    }
    
    //MARK: - Action
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private methods
    
    private func requestMovieDetails() {
        guard let movieTile = movieTile else { return }
        MovieService.shared.requestMoviesDetails(movieId: movieTile.movieId) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.loadDetails(movie: movie)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadDetails(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDetailLabel.text = movie.overview.text(defaultIfEmpty: "None summary provide")
        studioListLabel.text = movie.studioList.text(defaultIfEmpty:"Not Informed")
        genreListLabel.text = movie.genreList.text(defaultIfEmpty:"Not Informed")
        releaseDateLabel.text = movie.yearReleased?.text(defaultIfEmpty: "Not Informed")
        
        loadBackgroundImage(urlString: movie.backgroundImageFullPath)
        starRatingView.setupStars(voteAverage: movie.voteAverage ?? 0)
    }
    
    private func loadBackgroundImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        ImageDownloader.shared.getImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.movieBackgroundImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

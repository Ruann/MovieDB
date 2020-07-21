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
    
    @IBOutlet weak var backgroundImageFallView: UIView! {
        didSet {
            backgroundImageFallView.layer.roundCorners(cornerMasks: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: backgroundImageRadius)
        }
    }
    
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var backgroundImageActivityIndicator: UIActivityIndicatorView!
    
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
    
    @IBOutlet weak var studiosLabel: UILabel! {
        didSet {
            studiosLabel.text = AppStrings.MovieDetail.studios
        }
    }
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.text = AppStrings.MovieDetail.genre
        }
    }
    @IBOutlet weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.text = AppStrings.MovieDetail.release
        }
    }
    @IBOutlet weak var detailsLoadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieDetailsView: UIView!
    
    //MARK: - Properties
    
    static var identifier = "MovieDetailViewController"
    
    private var movieTile: MovieTile?
    
    //MARK: - Constants
    
    let backgroundImageRadius: CGFloat = 15.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLostInternetConnection), name: .lostInternetConnection, object: nil)
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
            guard let `self` = self else { return }
            
            self.detailsLoadActivityIndicator.stopAnimating()
            switch result {
                case .success(let movie):
                    self.loadDetails(movie: movie)
                    self.showDetailsViews()
                case .failure(let error):
                    self.showDefaultValues()
                    self.backgroundImageActivityIndicator.stopAnimating()
                    self.noImageLabel.isHidden = false
                    print(error.localizedDescription)
            }
        }
    }
    
    private func loadDetails(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDetailLabel.text = movie.overview.text(defaultIfEmpty: "None summary provide")
        studioListLabel.text = movie.studioList.text(defaultIfEmpty: "Not Informed")
        genreListLabel.text = movie.genreList.text(defaultIfEmpty: "Not Informed")
        releaseDateLabel.text = movie.yearReleased?.text(defaultIfEmpty: "Not Informed")
        
        loadBackgroundImage(urlString: movie.backgroundImageFullPath)
        starRatingView.setupStars(voteAverage: movie.voteAverage ?? 0)
    }
    
    private func showDefaultValues() {
        movieTitleLabel.text = movieTile?.title
        starRatingView.setupStars(voteAverage: movieTile?.voteAverage ?? 0)
        
        movieTitleLabel.isHidden = false
        starRatingView.isHidden = false
        backgroundImageFallView.isHidden = false
    }
    
    private func showDetailsViews() {
        backgroundImageFallView.isHidden = false
        movieDetailsView.isHidden = false
        movieTitleLabel.isHidden = false
        starRatingView.isHidden = false
    }
    
    private func loadBackgroundImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.backgroundImageActivityIndicator.stopAnimating()
            self.noImageLabel.isHidden = false
            return
        }
        
        ImageDownloader.shared.getImage(url: url) { [weak self] result in
            guard let `self` = self else { return }
            
            self.backgroundImageActivityIndicator.stopAnimating()
            
            switch result {
                case .success(let image):
                    self.movieBackgroundImageView.image = image
                case .failure(let error):
                    self.noImageLabel.isHidden = false
                    print(error.localizedDescription)
            }
        }
    }
    
    @objc private func onLostInternetConnection(_ notification:Notification) {
        DispatchQueue.main.async() { [weak self] in
            self?.showNoNetworkAlert()
        }
    }
}

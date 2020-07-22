//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Ruann Homem on 18/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

//MARK: - MovieDetailViewController

final class MovieDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var backgroundImageFallView: UIView! {
        didSet {
            backgroundImageFallView.layer.roundCorners(cornerMasks: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: backgroundImageRadius)
        }
    }
    
    @IBOutlet private weak var noImageLabel: UILabel!
    @IBOutlet private weak var backgroundImageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var movieBackgroundImageView: UIImageView! {
        didSet {
            movieBackgroundImageView.layer.roundCorners(cornerMasks: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: backgroundImageRadius)
        }
    }
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieDetailLabel: UILabel!
    @IBOutlet private weak var studioListLabel: UILabel!
    @IBOutlet private weak var genreListLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var starRatingView: StarRatingView!
    
    @IBOutlet private weak var studiosLabel: UILabel! {
        didSet {
            studiosLabel.text = AppStrings.MovieDetail.studios
        }
    }
    @IBOutlet private weak var genreLabel: UILabel! {
        didSet {
            genreLabel.text = AppStrings.MovieDetail.genre
        }
    }
    
    @IBOutlet private weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.text = AppStrings.MovieDetail.release
        }
    }
    
    @IBOutlet private weak var detailsLoadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var movieDetailsView: UIView!
    
    //MARK: - Properties
    
    static let identifier = "MovieDetailViewController"
    
    private var movieTile: MovieTile?
    
    //MARK: - Constants
    
    private let backgroundImageRadius: CGFloat = 15.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLostInternetConnection), name: .lostInternetConnection, object: nil)
        requestMovieDetails()
    }
    
    //MARK: - Public methods
    
    func load(_ movieTile: MovieTile) {
        self.movieTile = movieTile
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
                case .failure(_):
                    self.showDefaultValues()
                    self.backgroundImageActivityIndicator.stopAnimating()
                    self.noImageLabel.isHidden = false
            }
        }
    }
    
    private func loadDetails(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDetailLabel.text = movie.overview.text(defaultIfEmpty: AppStrings.MovieDetail.missingSummary)
        studioListLabel.text = movie.studioList.text(defaultIfEmpty: AppStrings.MovieDetail.notInformed)
        genreListLabel.text = movie.genreList.text(defaultIfEmpty: AppStrings.MovieDetail.notInformed)
        releaseDateLabel.text = movie.yearReleased?.text(defaultIfEmpty: AppStrings.MovieDetail.notInformed)
        
        loadBackgroundImage(urlString: movie.backgroundImageFullPath)
        starRatingView.setup(voteAverage: movie.voteAverage ?? 0)
    }
    
    private func showDefaultValues() {
        movieTitleLabel.text = movieTile?.title
        starRatingView.setup(voteAverage: movieTile?.voteAverage ?? 0)
        
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
            backgroundImageActivityIndicator.stopAnimating()
            noImageLabel.isHidden = false
            return
        }
        
        ImageDownloader.shared.requestImage(url: url) { [weak self] result in
            guard let `self` = self else { return }
            
            self.backgroundImageActivityIndicator.stopAnimating()
            
            switch result {
                case .success(let image):
                    self.movieBackgroundImageView.image = image
                case .failure(_):
                    self.noImageLabel.isHidden = false
            }
        }
    }
    
    @objc private func onLostInternetConnection(_ notification:Notification) {
        DispatchQueue.main.async() { [weak self] in
            self?.showNoNetworkAlert()
        }
    }
}

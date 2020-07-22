//
//  MovieCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = posterRadius
            posterImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var backgroundFallback: UIView! {
        didSet {
            backgroundFallback.layer.cornerRadius = posterRadius
            backgroundFallback.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var status: UILabel! {
        didSet {
            status.text = AppStrings.MovieCell.noPosterAvailable
        }
    }
    @IBOutlet private weak var posterActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var starRatingView: StarRatingView!
    
    //MARK: - Properties
    
    static var nib = UINib(nibName: "MovieCell", bundle: nil)
    static let identifier = "MovieCell"
    
    private var imageDownloadTask: URLSessionDataTask?
    
    //MARK: - Constants
    
    private let posterRadius: CGFloat = 20.0
    
    //MARK: - Life Cycle
    
    func prepare(title: String, posterUrl: String, voteAverage: Double) {
        titleLabel.text = title
        starRatingView.setup(voteAverage: voteAverage)
        loadPosterImage(posterUrlString: posterUrl)
    }
    
    func prepareWithDefaultValues() {
        starRatingView.isHidden = true
        posterActivityIndicator.stopAnimating()
        status.text = AppStrings.Error.movieRequestErrorMessage
        status.isHidden = false
    }
    
    override func prepareForReuse() {
        imageDownloadTask?.cancel()
        posterImage.image = nil
        titleLabel.text = nil
        status.isHidden = true
        posterActivityIndicator.isHidden = false
        starRatingView.isHidden = false
        starRatingView.reset()
        status.text = AppStrings.MovieCell.noPosterAvailable
    }
    
    //MARK: - Private Methods
    
    private func loadPosterImage(posterUrlString: String) {
        guard let posterUrl = URL(string: posterUrlString) else {
            posterActivityIndicator.stopAnimating()
            status.isHidden = false
            return
        }
        
        posterActivityIndicator.startAnimating()
        
        imageDownloadTask = ImageDownloader.shared.requestImage(url: posterUrl) { [weak self] result in
            self?.posterActivityIndicator.stopAnimating()
            switch result {
            case .success(let image):
                self?.posterImage.image = image
            case .failure(_):
                self?.status.isHidden = false
            }
        }
    }
}

//
//  MovieCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = posterRadius
            posterImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var backgroundFallback: UIView! {
        didSet {
            backgroundFallback.layer.cornerRadius = posterRadius
            backgroundFallback.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var noPosterLabel: UILabel!
    @IBOutlet weak var posterActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    //MARK: - Properties
    
    static var nib = UINib(nibName: "MovieCell", bundle: nil)
    static var identifier = "MovieCell"
    
    private var imageDownloadTask: URLSessionDataTask?
    
    //MARK: - Constants
    
    let posterRadius: CGFloat = 20.0
    
    //MARK: - Life Cycle
    
    func prepare(title: String, posterUrl: String, voteAverage: Double) {
        titleLabel.text = title
        starRatingView.setupStars(voteAverage: voteAverage)
        loadPosterImage(posterUrlString: posterUrl)
    }
    
    override func prepareForReuse() {
        imageDownloadTask?.cancel()
        posterImage.image = nil
        titleLabel.text = nil
        noPosterLabel.isHidden = true
        posterActivityIndicator.isHidden = false
        starRatingView.reset()
    }
    
    //MARK: - Private Methods
    
    private func loadPosterImage(posterUrlString: String) {
        guard let posterUrl = URL(string: posterUrlString) else {
            posterActivityIndicator.stopAnimating()
            noPosterLabel.isHidden = false
            return
        }
        
        posterActivityIndicator.startAnimating()
        
        imageDownloadTask = ImageDownloader.shared.getImage(url: posterUrl) { [weak self] result in
            self?.posterActivityIndicator.stopAnimating()
            switch result {
            case .success(let image):
                self?.posterImage.image = image
            case .failure(let error):
                self?.noPosterLabel.isHidden = false
                print(error.localizedDescription)
            }
        }
    }
}

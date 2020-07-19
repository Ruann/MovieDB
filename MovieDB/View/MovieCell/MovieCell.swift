//
//  MovieCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    private var imageDownloadTask: URLSessionDataTask?
    
    @IBOutlet private weak var posterImage: UIImageView! {
        didSet {
            posterImage.layer.cornerRadius = 20
            posterImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var backgroundFallback: UIView! {
        didSet {
            backgroundFallback.layer.cornerRadius = 20
            backgroundFallback.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var noPosterLabel: UILabel!
    @IBOutlet weak var posterActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    func prepare(title: String, posterUrl: String, voteAverage: Double) {
        titleLabel.text = title
        starRatingView.setupStars(voteAverage: voteAverage)
        loadPosterImage(posterUrlString: posterUrl)
    }
    
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
    
    override func prepareForReuse() {
        imageDownloadTask?.cancel()
        posterImage.image = nil 
        titleLabel.text = nil
        noPosterLabel.isHidden = true
        posterActivityIndicator.isHidden = false
    }
}

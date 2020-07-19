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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    
    
    func prepare(title: String, posterUrl: String, voteAverage: Double) {
        titleLabel.text = title
        starRatingView.setupStars(voteAverage: voteAverage)
        
        imageDownloadTask = ImageDownloader.shared.getImage(url: posterUrl) { result in
            switch result {
            case .success(let image):
                self.posterImage.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepareForReuse() {
        imageDownloadTask?.cancel()
        posterImage.image = nil 
        titleLabel.text = nil
    }
}

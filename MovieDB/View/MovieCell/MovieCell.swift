//
//  MovieCell.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func prepare(title: String, posterUrl: String) {
        titleLabel.text = title
        
        ImageDownloader.shared.getImage(url: posterUrl) { result in
            switch result {
            case .success(let image):
                self.posterImage.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepareForReuse() {
        posterImage.image = nil 
        titleLabel.text = nil
    }
}

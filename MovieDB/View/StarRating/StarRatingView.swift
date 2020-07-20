//
//  StarRatingView.swift
//  MovieDB
//
//  Created by Ruann Homem on 19/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

class StarRatingView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var firstStarImageView: UIImageView!
    @IBOutlet weak var secondStarImageView: UIImageView!
    @IBOutlet weak var thirdStarImageView: UIImageView!
    @IBOutlet weak var fourthStarImageView: UIImageView!
    @IBOutlet weak var fifthStarImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupStars(voteAverage: Double) {
        if voteAverage > 1.0 {
            firstStarImageView.alpha = 1
        }
        
        if voteAverage > 2.0 {
            secondStarImageView.alpha = 1
        }
        
        if voteAverage > 4.0 {
            thirdStarImageView.alpha = 1
        }
        
        if voteAverage > 6.0 {
            fourthStarImageView.alpha = 1
        }
        
        if voteAverage > 8.0 {
            fifthStarImageView.alpha = 1
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("StarRatingView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = frame
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//
//  StarRatingView.swift
//  MovieDB
//
//  Created by Ruann Homem on 19/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit


final class StarRatingView: UIView {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var firstStarImageView: UIImageView!
    @IBOutlet private weak var secondStarImageView: UIImageView!
    @IBOutlet private weak var thirdStarImageView: UIImageView!
    @IBOutlet private weak var fourthStarImageView: UIImageView!
    @IBOutlet private weak var fifthStarImageView: UIImageView!
    
    //MARK: - Constants
    
    private let nibName = "StarRatingView"
    private let firstStarMinimunVoteAverage = 1.0
    private let secondStarMinimunVoteAverage = 2.0
    private let thirdStarMinimunVoteAverage = 4.0
    private let fourhtStarMinimunVoteAverage = 6.0
    private let fifthStarMinimunVoteAverage = 8.0
    private let starDisableAlpha: CGFloat = 0.3
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
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
    
    //MARK: - Public Methods
    
    func setup(voteAverage: Double) {
        if voteAverage > firstStarMinimunVoteAverage {
            firstStarImageView.alpha = 1
        }
        
        if voteAverage > secondStarMinimunVoteAverage {
            secondStarImageView.alpha = 1
        }
        
        if voteAverage > thirdStarMinimunVoteAverage {
            thirdStarImageView.alpha = 1
        }
        
        if voteAverage > fourhtStarMinimunVoteAverage {
            fourthStarImageView.alpha = 1
        }
        
        if voteAverage > fifthStarMinimunVoteAverage {
            fifthStarImageView.alpha = 1
        }
    }
    
    func reset() {
        firstStarImageView.alpha = starDisableAlpha
        secondStarImageView.alpha = starDisableAlpha
        thirdStarImageView.alpha = starDisableAlpha
        fourthStarImageView.alpha = starDisableAlpha
        fifthStarImageView.alpha = starDisableAlpha
    }
}

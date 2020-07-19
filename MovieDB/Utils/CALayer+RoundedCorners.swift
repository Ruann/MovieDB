//
//  UIView+RoundedCorners.swift
//  MovieDB
//
//  Created by Ruann Homem on 19/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

extension CALayer {
   func roundCorners(cornerMasks: CACornerMask, radius: CGFloat) {
        cornerRadius = radius
        masksToBounds = true
        maskedCorners = cornerMasks
    }
}

//
//  UILabelExtensions.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

extension UILabel {
    func addLineSpacing(_ spacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attrString = NSMutableAttributedString(string: text ?? String.empty)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value:paragraphStyle,
                                range:NSMakeRange(0, attrString.length))
        attributedText = attrString
    }
}

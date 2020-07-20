//
//  StringExtensions.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

extension String {
    static var empty: String {
        return ""
    }
    
    static var separatorForList: String {
        return ", "
    }
    
    func text(defaultIfEmpty: String) -> String {
        return !isEmpty ? self : defaultIfEmpty
    }
}

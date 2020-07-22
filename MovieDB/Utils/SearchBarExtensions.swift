//
//  SearchBarExtensions.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

extension UISearchBar {
    func customize() {
        self[keyPath: \.searchTextField].font = UIFont(name: "OpenSans-regular", size: 15.0)
        self[keyPath: \.searchTextField].textColor = .white
        searchTextField.leftView?.tintColor = .white
    }
}

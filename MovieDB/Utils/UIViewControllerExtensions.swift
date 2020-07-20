//
//  UIViewControllerExtensions.swift
//  MovieDB
//
//  Created by Ruann Homem on 20/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

extension UIViewController {
    func  loadFromMainBundle(viewControllerIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
}

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
    
    func showNoNetworkAlert() {
        let alertcontroller = UIAlertController(title: AppStrings.Network.alertTitle, message: AppStrings.Network.alertMessage, preferredStyle: .alert)
        alertcontroller.addAction(UIAlertAction(title: AppStrings.Global.ok, style: .default, handler: { [weak  self] _ in
            self?.dismiss(animated: true)
        }))
        
        present(alertcontroller, animated: true)
    }
}

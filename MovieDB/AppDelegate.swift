//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var configuration: Configuration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadConfiguration()
        return true
    }
    
    private func loadConfiguration() {
        MovieService.shared.requestConfiguration { [weak self] result in
            print("get Configuration")
            switch result {
            case .success(let configuration):
                self?.configuration = configuration
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

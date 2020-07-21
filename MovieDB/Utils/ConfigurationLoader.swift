//
//  ConfigurationLoader.swift
//  MovieDB
//
//  Created by Ruann Homem on 19/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let configurationLoaded = Notification.Name("configurationLoaded")
}

class ConfigurationLoader {
    static let shared = ConfigurationLoader()
    
    private init() {}
    
    func loadConfiguration() {
        MovieService.shared.requestConfiguration { result in
            switch result {
                case .success(let configuration):
                    Configuration.shared = configuration
                    
                    NotificationCenter.default.post(name: .configurationLoaded, object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

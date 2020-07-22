//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Ruann Homem on 17/07/20.
//  Copyright © 2020 Ruann Homem. All rights reserved.
//

import UIKit
import Network

//merge
extension Notification.Name {
    static let lostInternetConnection = Notification.Name("lostInternetConnection")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var monitor: NWPathMonitor?
    private let networkMonitorQueueName = "NetworkMonitor"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ConfigurationLoader.shared.loadConfiguration()
        return true
    }
    
    func startNetworkMonitor() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                NotificationCenter.default.post(name: .lostInternetConnection, object: nil)
                self?.monitor?.cancel()
            }
        }
        
        let queue = DispatchQueue(label: networkMonitorQueueName)
        monitor?.start(queue: queue)
    }
}

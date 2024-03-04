//
//  NetworkConnection.swift
//  iOS App
//
//  Created by Qualwebs on 18/01/24.
//

import Foundation

import Network
import UIKit
class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private weak var viewController: UIViewController?
    
    private init() {
        startMonitoringNetwork()
    }
    
    func startMonitoringNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard self != nil else { return }
                
                if path.status == .satisfied {
                    // Network is available
                    print("Network is available")
                    setOnlineStatus(isOnline: true)
                } else {
                    // Network is not available
                    print("Network is not available")
                    setOnlineStatus(isOnline: false)
                }
            }
        }
        
        // Start monitoring
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoringNetwork() {
        print("Network Monitor Off")
        monitor.cancel()
    }
}

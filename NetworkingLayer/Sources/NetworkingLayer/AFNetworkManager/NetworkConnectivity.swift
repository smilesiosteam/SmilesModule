//
//  NetworkConnectivity.swift
//  YayOrNay
//
//  Created by MyAList on 1/5/19.
//  Copyright © 2019 Mahmoud Fathy. All rights reserved.
//

import Alamofire
import Foundation

class NetworkConnectivity {
    static let shared = NetworkConnectivity()
    
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    private let concurrentQueue = DispatchQueue(label: "com.example.NetworkConnectivity.concurrentQueue", attributes: .concurrent)
    private var _lastStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    private var _currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    
    private init() {}
    
    var lastStatus: NetworkReachabilityManager.NetworkReachabilityStatus? {
        return concurrentQueue.sync {
            _lastStatus
        }
    }
    
    var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus? {
        return concurrentQueue.sync {
            _currentStatus
        }
    }
    
    func startNetworkReachabilityObserver() {
        var networkStatusMessage: String?
        self.reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self else {
                return
            }
            
            self.concurrentQueue.async(flags: .barrier) {
                if self._currentStatus != nil {
                    self._lastStatus = self._currentStatus
                }
                self._currentStatus = status
            }
            
            switch status {
            case .notReachable:
                networkStatusMessage = "network"
            case .unknown:
                networkStatusMessage = "unknown.connection.error"
            case .reachable(.ethernetOrWiFi):
                networkStatusMessage = "connected.wifi"
            case .reachable(.cellular):
                networkStatusMessage = "connected.wwan"
            }
            
            print("Network Status\(networkStatusMessage ?? "")")
            
        })
    }
}

//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 10/01/2024.
//

import Foundation
import Alamofire

class NetworkManagerSessionHandler: SessionDelegate {
    
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let urlString = task.currentRequest?.url?.absoluteString, !urlString.contains("https://maps.googleapis.com/maps/api") && !urlString.contains("https://nominatim.openstreetmap.org") else {
            completionHandler(.useCredential, nil)
            return
        }
        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        if PublicKeyPinner().validate(serverTrust: trust) {
            completionHandler(.useCredential, nil)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
    
}

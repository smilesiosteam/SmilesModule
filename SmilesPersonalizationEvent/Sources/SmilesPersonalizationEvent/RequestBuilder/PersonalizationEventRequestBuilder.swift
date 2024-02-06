//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//

import Foundation
import NetworkingLayer

// if you wish you can have multiple services like this in a project
enum PersonalizationEventRequestBuilder {
    
    // organise all the end points here for clarity
    case registerPersonalizationEvent(request: RegisterPersonalizationEventRequest)

    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .registerPersonalizationEvent:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseURL: String, endPoint: PersonalizationEventEndPoint) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(from: baseURL, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .registerPersonalizationEvent(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from baseURL: String, for endPoint: PersonalizationEventEndPoint) -> String {
        
        let endPoint = endPoint.serviceEndPoints
        switch self {
        case .registerPersonalizationEvent:
            return "\(baseURL)\(endPoint)"
        }
        
    }
}

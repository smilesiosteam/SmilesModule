//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 21/11/2023.
//

import Foundation
import NetworkingLayer


enum AddOrEditAddressRequestBuilder {
    
    
    case getLocationsNickNames(request: SaveAddressRequestModel)
    case saveAddress(request: SaveAddressRequestModel)
    case getAllAddresses(request: RegisterLocationRequest)
    case removeAddress(request: RemoveAddressRequestModel)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getLocationsNickNames:
            return .POST
        case .saveAddress:
            return .POST
        case .getAllAddresses:
            return .POST
        case .removeAddress:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    public func createRequest(baseUrl: String, endPoint: ManageAddressEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, endPoint: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getLocationsNickNames(let request):
            return request
        case .saveAddress(request: let request):
            return request
        case .getAllAddresses(request: let request):
            return request
        case .removeAddress(request: let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(baseUrl: String, endPoint: ManageAddressEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

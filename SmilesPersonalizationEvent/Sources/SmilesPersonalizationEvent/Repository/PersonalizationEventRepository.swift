//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//  

import Foundation
import Combine
import NetworkingLayer

protocol PersonalizationEventServiceable {
    func registerPersonalizationEvent(request: RegisterPersonalizationEventRequest) -> AnyPublisher<RegisterPersonalizationEventResponse, NetworkError>
}

class PersonalizationEventRepository: PersonalizationEventServiceable {
    
    private var networkRequest: Requestable
    private var baseURL: String
    private var endPoint: PersonalizationEventEndPoint

  // inject this for testability
    init(networkRequest: Requestable, baseURL: String, endPoint: PersonalizationEventEndPoint) {
        self.networkRequest = networkRequest
        self.baseURL = baseURL
        self.endPoint = endPoint
    }
    
    func registerPersonalizationEvent(request: RegisterPersonalizationEventRequest) -> AnyPublisher<RegisterPersonalizationEventResponse, NetworkError> {
        let endPoint = PersonalizationEventRequestBuilder.registerPersonalizationEvent(request: request)
        let request = endPoint.createRequest(
            baseURL: baseURL,
            endPoint: self.endPoint
        )
        
        return self.networkRequest.request(request)
    }
}

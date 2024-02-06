//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 28/07/2023.
//

import Foundation
import Combine
import NetworkingLayer

public protocol TopOffersServiceable {
    func getTopOffersService(request: GetTopOffersRequestModel) -> AnyPublisher<GetTopOffersResponseModel, NetworkError>
}

// GetTopOffersRepository
public class GetTopOffersRespository: TopOffersServiceable {
    private var networkRequest: Requestable
    private var baseUrl: String

  // inject this for testability
    public init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
  
    public func getTopOffersService(request: GetTopOffersRequestModel) -> AnyPublisher<GetTopOffersResponseModel, NetworkingLayer.NetworkError> {
        let endPoint = TopOffersRequestBuilder.getTopOffers(request: request)
        let request = endPoint.createRequest(
            baseUrl: baseUrl
        )
        
        return self.networkRequest.request(request)
    }
    
}

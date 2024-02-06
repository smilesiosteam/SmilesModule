//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 28/07/2023.
//

import Foundation
import Combine
import NetworkingLayer

public class TopOffersViewModel: NSObject {

    // MARK: - INPUT. View event methods
    public enum Input {
        case getTopOffers(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?, isGuestUser: Bool, baseUrl: String)
    }
    
    public enum Output {
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - INPUT. View event methods
extension TopOffersViewModel {
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getTopOffers(let menuItemType, let bannerType, let categoryId, let bannerSubType, let isGuestUser, let baseUrl):
                self?.getAllTopOffers(for: menuItemType, bannerType: bannerType, categoryId: categoryId, bannerSubType: bannerSubType, isGuestUser: isGuestUser, baseUrl: baseUrl)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // Get All Top Offers
    private func getAllTopOffers(for menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?, isGuestUser: Bool, baseUrl: String) {
        let getTopOffersRequest = GetTopOffersRequestModel(
            menuItemType: menuItemType,
            bannerType: bannerType,
            categoryId: categoryId,
            bannerSubType: bannerSubType,
            isGuestUser: isGuestUser
        )
        
        let service = GetTopOffersRespository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: baseUrl
        )
        
        service.getTopOffersService(request: getTopOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchTopOffersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchTopOffersDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}

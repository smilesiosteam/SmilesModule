//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager

@objc open class PersonalizationEventHandler: NSObject {
    @objc public static let shared = PersonalizationEventHandler()
    private var cancellables = Set<AnyCancellable>()
    
    @objc public func registerPersonalizationEvent(
        eventName: String,
        urlScheme: String? = nil,
        offerId: String? = nil,
        restaurantId: String? = nil,
        accountType: String? = GetEligibilityMatrixResponse.sharedInstance.accountType ?? AppCommonMethods.loadCustomObject(for: "accountType"),
        bannerType: String? = nil,
        menuItemType: String? = nil,
        recommendationModelEvent: String? = nil,
        cuisineName: String? = nil,
        categoryName: String? = nil,
        source: String? = nil,
        mambaSource: String? = nil
    ) {
        let registerPersonalizationEventRequest = RegisterPersonalizationEventRequest()
        registerPersonalizationEventRequest.eventName = eventName
        registerPersonalizationEventRequest.urlScheme = urlScheme
        
        if let offerId {
            registerPersonalizationEventRequest.offerId = offerId
        } else {
            if let urlScheme, urlScheme.contains("offer") {
                let expectedOfferId = AppCommonMethods.getParameterFromUrl(url: urlScheme, isLastParameter: false, index: 3)
                registerPersonalizationEventRequest.offerId = expectedOfferId
            }
        }
        
        if let restaurantId {
            registerPersonalizationEventRequest.restaurantId = restaurantId
        } else {
            if let urlScheme, urlScheme.contains("restaurantId") {
                let expectedRestaurantId = AppCommonMethods.getParameterFromUrl(url: urlScheme, isLastParameter: false, index: 3)
                registerPersonalizationEventRequest.restaurantId = expectedRestaurantId
            }
        }
        
        registerPersonalizationEventRequest.accountType = accountType ?? nil
        registerPersonalizationEventRequest.bannerType = bannerType
        registerPersonalizationEventRequest.menuItemType = menuItemType
        registerPersonalizationEventRequest.recommendationModelEvent = recommendationModelEvent
        registerPersonalizationEventRequest.cuisineName = cuisineName
        registerPersonalizationEventRequest.categoryName = categoryName
        registerPersonalizationEventRequest.source = source ?? "app"
        registerPersonalizationEventRequest.mambaSource = mambaSource
        
        let service = PersonalizationEventRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseURL: AppCommonMethods.serviceBaseUrl,
            endPoint: .registerAppEvent
        )
        
        service.registerPersonalizationEvent(request: registerPersonalizationEventRequest)
            .sink { completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    debugPrint("REGISTER PERSONALIZATION EVENT ERROR: \(error)")
                default: break
                }
            } receiveValue: { response in
                debugPrint("REGISTER PERSONALIZATION EVENT SUCCESS: \(response.successMessage ?? "")")
            }
        .store(in: &cancellables)
    }
    
    @objc func registerPersonalizationEvent(accountType: String? = GetEligibilityMatrixResponse.sharedInstance.accountType, additionalInfo: Any?) {
        var parsedAdditionalInfo = [BaseMainResponseAdditionalInfo]()
        
        if let additionalInfoArray = additionalInfo as? [Any] {
            additionalInfoArray.forEach { item in
                if let additionalInfoItem = item as? [String: Any] {
                    let baseMainAdditionalInfo = BaseMainResponseAdditionalInfo()
                    baseMainAdditionalInfo.name = additionalInfoItem["name"] as? String
                    baseMainAdditionalInfo.value = additionalInfoItem["value"] as? String
                    
                    parsedAdditionalInfo.append(baseMainAdditionalInfo)
                }
            }
        } else if let additionalInfoDictionary = additionalInfo as? [String: Any] {
            additionalInfoDictionary.forEach { item in
                let value = item.value
                
                if item.key == "aps" {
                    let jsonData = try? JSONSerialization.data(withJSONObject: value)
                    let dataString = String(data: jsonData ?? Data(), encoding: .utf8)
                    
                    let baseMainAdditionalInfo = BaseMainResponseAdditionalInfo()
                    baseMainAdditionalInfo.name = item.key
                    baseMainAdditionalInfo.value = dataString
                    
                    parsedAdditionalInfo.append(baseMainAdditionalInfo)
                } else {
                    let baseMainAdditionalInfo = BaseMainResponseAdditionalInfo()
                    baseMainAdditionalInfo.name = item.key
                    baseMainAdditionalInfo.value = item.value as? String
                    
                    parsedAdditionalInfo.append(baseMainAdditionalInfo)
                }
            }
        }
        
        SmilesBaseMainRequestManager.shared.baseMainRequestConfigs?.additionalInfo = parsedAdditionalInfo
        
        let registerPersonalizationEventRequest = RegisterPersonalizationEventRequest()
        registerPersonalizationEventRequest.eventName = "push_notification_received"
        registerPersonalizationEventRequest.accountType = accountType ?? nil
        
        let service = PersonalizationEventRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseURL: AppCommonMethods.serviceBaseUrl,
            endPoint: .registerAppEvent
        )
        
        service.registerPersonalizationEvent(request: registerPersonalizationEventRequest)
            .sink { completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    debugPrint("REGISTER PERSONALIZATION EVENT FOR PUSH ERROR: \(error)")
                    SmilesBaseMainRequestManager.shared.baseMainRequestConfigs?.additionalInfo = []
                default: break
                }
            } receiveValue: { response in
                debugPrint("REGISTER PERSONALIZATION EVENT FOR PUSH SUCCESS: \(response.successMessage ?? "")")
                SmilesBaseMainRequestManager.shared.baseMainRequestConfigs?.additionalInfo = []
            }
        .store(in: &cancellables)
    }
}

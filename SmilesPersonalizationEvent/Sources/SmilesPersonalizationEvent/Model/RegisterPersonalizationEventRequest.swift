//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

public class RegisterPersonalizationEventRequest: SmilesBaseMainRequest {
    public var accountType: String?
    public var urlScheme: String?
    public var offerId: String?
    public var bannerType: String?
    public var eventName: String?
    public var restaurantId: String?
    public var menuItemType: String?
    public var recommendationModelEvent: String?
    public var cuisineName: String?
    public var categoryName: String?
    public var source: String?
    public var mambaSource: String?
    
    enum CodingKeys: String, CodingKey {
        case accountType
        case urlScheme
        case offerId
        case bannerType
        case eventName
        case restaurantId
        case menuItemType
        case recommendationModelEvent
        case cuisineName
        case categoryName
        case source
        case mambaSource
    }
    
    public override init() {
        super.init()
    }
    
    public init(
        accountType: String? = nil,
        urlScheme: String? = nil,
        offerId: String? = nil,
        bannerType: String? = nil,
        eventName: String?,
        restaurantId: String? = nil,
        menuItemType: String? = nil,
        recommendationModelEvent: String? = nil,
        cuisineName: String? = nil,
        categoryName: String? = nil,
        source: String? = nil,
        mambaSource: String? = nil
    ) {
        super.init()
        self.accountType = accountType
        self.urlScheme = urlScheme
        self.offerId = offerId
        self.bannerType = bannerType
        self.eventName = eventName
        self.restaurantId = restaurantId
        self.menuItemType = menuItemType
        self.recommendationModelEvent = recommendationModelEvent
        self.cuisineName = cuisineName
        self.categoryName = categoryName
        self.source = source
        self.mambaSource = mambaSource
    }

    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.accountType, forKey: .accountType)
        try container.encodeIfPresent(self.urlScheme, forKey: .urlScheme)
        try container.encodeIfPresent(self.offerId, forKey: .offerId)
        try container.encodeIfPresent(self.bannerType, forKey: .bannerType)
        try container.encodeIfPresent(self.eventName, forKey: .eventName)
        try container.encodeIfPresent(self.restaurantId, forKey: .restaurantId)
        try container.encodeIfPresent(self.menuItemType, forKey: .menuItemType)
        try container.encodeIfPresent(self.recommendationModelEvent, forKey: .recommendationModelEvent)
        try container.encodeIfPresent(self.cuisineName, forKey: .cuisineName)
        try container.encodeIfPresent(self.categoryName, forKey: .categoryName)
        try container.encodeIfPresent(self.source, forKey: .source)
        try container.encodeIfPresent(self.mambaSource, forKey: .mambaSource)
    }
    
    public func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}

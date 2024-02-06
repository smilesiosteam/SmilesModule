//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 28/07/2023.
//

import Foundation
import SmilesBaseMainRequestManager

public class GetTopOffersRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    public var menuItemType: String?
    public var bannerType: String?
    public var categoryId: Int?
    public var bannerSubType: String?
    public var isGuestUser: Bool?

    public init(menuItemType: String?, bannerType: String?, categoryId: Int?, bannerSubType: String?, isGuestUser: Bool?) {
        super.init()
        self.menuItemType = menuItemType
        self.bannerType = bannerType
        self.categoryId = categoryId
        self.bannerSubType = bannerSubType
        self.isGuestUser = isGuestUser
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    
    public enum CodingKeys: CodingKey {
        case menuItemType
        case bannerType
        case categoryId
        case bannerSubType
        case isGuestUser
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.menuItemType, forKey: .menuItemType)
        try container.encodeIfPresent(self.bannerType, forKey: .bannerType)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
        try container.encodeIfPresent(self.bannerSubType, forKey: .bannerSubType)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
    }
    
}

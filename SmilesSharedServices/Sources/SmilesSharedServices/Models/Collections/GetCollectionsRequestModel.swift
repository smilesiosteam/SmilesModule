//
//  GetCollectionsRequestModel.swift
//  House
//
//  Created by Shahroze Zaheer on 10/31/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager

public class GetCollectionsRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
   public var categoryId: Int?
   public var menuItemType: String?
   public var isGuestUser: Bool?
    public var themeId: String?
    
    public init(categoryId: Int?, menuItemType: String?, isGuestUser: Bool?,themeId: String? = nil) {
        super.init()
        self.categoryId = categoryId
        self.menuItemType = menuItemType
        self.isGuestUser = isGuestUser
        self.themeId = themeId
    }
    
   public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case categoryId
        case menuItemType
        case isGuestUser
        case themeId
    }
    
   public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
        try container.encodeIfPresent(self.menuItemType, forKey: .menuItemType)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
       try container.encodeIfPresent(self.themeId, forKey: .themeId)
    }
}

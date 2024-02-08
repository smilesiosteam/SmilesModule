//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import Foundation

public enum ManCityHomeEndPoints: String, CaseIterable {
    case getSubscriptionInfo
    case quickAccessList
}

extension ManCityHomeEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .getSubscriptionInfo:
            return "mancity/subscription"
        case .quickAccessList:
            return "mancity/quick-access"
        }
    }
}


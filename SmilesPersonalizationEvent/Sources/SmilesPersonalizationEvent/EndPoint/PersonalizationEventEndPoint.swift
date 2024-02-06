//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//

import Foundation

public enum PersonalizationEventEndPoint: String, CaseIterable {
    case registerAppEvent
}

extension PersonalizationEventEndPoint {
    var serviceEndPoints: String {
        switch self {
        case .registerAppEvent:
            return "personalization/register-event"
        }
    }
}

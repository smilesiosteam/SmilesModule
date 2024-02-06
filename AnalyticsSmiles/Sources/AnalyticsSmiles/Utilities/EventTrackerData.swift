//
//  EventTrackerData.swift
//  
//
//  Created by Hanan Ahmed on 10/5/22.
//

import Foundation

public protocol EventTrackerData {
    var eventType: String { get }
    var parameter: [String : Any] { get }
}

extension EventTrackerData {
    var parameter: [String : Any] {
        [:]
    }
}

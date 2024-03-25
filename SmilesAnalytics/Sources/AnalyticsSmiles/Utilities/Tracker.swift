//
//  Tracker.swift
//  
//
//  Created by Hanan Ahmed on 10/17/22.
//

import Foundation

public struct Tracker: EventTrackerData {
    fileprivate var name: String
    public var eventType: String {
        return name
    }

    public var parameter: [String : Any] = [:]
    
    public init(eventType: String, parameters: [String : Any]) {
        self.name = eventType
        self.parameter = parameters
    }
}

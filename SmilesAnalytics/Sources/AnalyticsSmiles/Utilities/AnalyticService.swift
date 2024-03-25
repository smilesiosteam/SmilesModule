//
//  AnalyticService.swift
//  
//
//  Created by Hanan Ahmed on 10/5/22.
//

import Foundation
import Combine

public protocol AnalyticService {
    func sendAnalyticTracker<TrackerData: EventTrackerData>(
        trackerData: TrackerData
    ) -> AnyPublisher<Bool, AnalyticsError>
    
}

//
//  AnalyticsError.swift
//  
//
//  Created by Hanan Ahmed on 10/11/22.
//

import Foundation

public enum AnalyticsError: Error, Equatable {
    case eventNotLogged(_ error: String)
}

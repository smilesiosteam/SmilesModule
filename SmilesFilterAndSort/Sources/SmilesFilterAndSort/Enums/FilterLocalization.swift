//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 07/11/2023.
//

import Foundation
import SmilesUtilities

public enum FilterLocalization {
    case filter
    case apply
    case search
    case clearAll
    case filtersSelected
    case noFilteredResultFoundTitle
    case noFilteredResultFoundDescription
    case sortByTitle
    case explore
    
    public var text: String {
        switch self {
        case .filter:
            return "FilterMainTitle".localizedString
        case .apply:
            return "FilterApply".localizedString
        case .search:
            return "Search".localizedString
        case .clearAll:
            return "FilterClearAll".localizedString
        case .filtersSelected:
            return "filtersSelected".localizedString
        case .noFilteredResultFoundTitle:
            return "NoFilteredResultFoundTitle".localizedString
        case .noFilteredResultFoundDescription:
            return "NoFilteredResultFoundDescription".localizedString
        case .sortByTitle:
            return "SortByTitle".localizedString
        case .explore:
            return "ExploreTitle".localizedString
        }
    }
}





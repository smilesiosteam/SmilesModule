//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 15/10/2023.
//

import Foundation
import SmilesUtilities

public class RegisterPersonalizationEventResponse: Codable {
    public var status: Double?
    public var successMessage: String?
    public var successPopupTitle: String?
    public var successPopupMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case successMessage
        case successPopupTitle
        case successPopupMessage
    }
    
    public init() {}

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Double.self, forKey: .status)
        successMessage = try values.decodeIfPresent(String.self, forKey: .successMessage)
        successPopupTitle = try values.decodeIfPresent(String.self, forKey: .successPopupTitle)
        successPopupMessage = try values.decodeIfPresent(String.self, forKey: .successPopupMessage)
    }
    
    public func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}

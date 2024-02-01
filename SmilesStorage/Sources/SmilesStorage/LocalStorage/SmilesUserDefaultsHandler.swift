//
//  File 2.swift
//  
//
//  Created by Abdul Rehman Amjad on 02/01/2024.
//

import Foundation

protocol SmilesObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode, noValue, unableToDecode
    
    var errorDescription: String {
        switch self {
        case .unableToEncode:
            return "Unable to encode"
        case .noValue:
            return "No value"
        case .unableToDecode:
            return "Unable to decode"
        }
    }
}

extension UserDefaults: SmilesObjectSavable {
    
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        if let value = value(forKey: forKey) as? Object {
            return value
        }
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
}

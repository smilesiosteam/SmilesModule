//
//  File.swift
//
//
//  Created by Abdul Rehman Amjad on 02/01/2024.
//

import Security
import Foundation

final class SmilesKeychain {
    
    func set(_ data: Data, forKey: String) {
        deleteData(forKey: forKey)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: forKey,
            kSecAttrAccount as String: forKey,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getData(_ key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    private func deleteData(forKey: String) {
        if getData(forKey) != nil {
            let query = [
                kSecClass as String             : kSecClassGenericPassword as String,
                kSecAttrAccount as String       : forKey] as [String : Any]
            
            SecItemDelete(query as CFDictionary)
        }
    }
    
}

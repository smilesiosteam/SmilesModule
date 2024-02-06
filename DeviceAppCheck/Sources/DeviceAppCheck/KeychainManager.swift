//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 28/03/2023.
//

import Foundation
import Security
class KeychainManager {
    static let shared = KeychainManager()
    func saveKeyId(data: String) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "AppAttestationKeyID",
                                    kSecValueData as String: data.data(using: .utf8)!]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func deleteKeyId() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "AppAttestationKeyID"]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    func getKeyId() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "AppAttestationKeyID",
                                    kSecReturnData as String: true]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            let data = result as! Data
            let password = String(data: data, encoding: .utf8)
            return password
        } else {
            return nil
        }
    }
}

//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 05/04/2023.
//

import DeviceCheck
import CryptoKit

@available(iOS 14.0, *)
internal class AppAttestor {
    static let shared = AppAttestor()
    func getAppAttestKeyId(_ completion:@escaping(String?,DCError.Code?)->Void) {
        guard let keyId = KeychainManager.shared.getKeyId() else {
            // The generateKey method returns an ID associated with the key.  The key itself is stored in the Secure Enclave
            DCAppAttestService.shared.generateKey(completionHandler: { keyId, error in
                if let dcError = error as? DCError {
                    completion(nil, dcError.code)
                    return
                }
                guard let keyId = keyId else {
                    print("key generate failed: \(error?.localizedDescription ?? "")")
                    completion(nil,.unknownSystemFailure)
                    return
                }

                // Cache the keyId for use at a later time.
                if !KeychainManager.shared.saveKeyId(data: keyId) {
                    print("KeyID could not be saved for app attest")
                }
                completion(keyId,nil)
            })
            return
        }

        completion(keyId,nil)
    }

    
    func certifyAppAttestKey(challenge: Data, tryCount:Int, completion:@escaping (String?,DCError.Code?) -> Void) {
        getAppAttestKeyId { keyId,keyError in
            guard let keyId = keyId else {
                completion(nil,keyError ?? .unknownSystemFailure)
                return
            }
            let hashValue = Data(SHA256.hash(data: challenge))

            // This method contacts Apple's server to retrieve an attestation object for the given hash value
            DCAppAttestService.shared.attestKey(keyId, clientDataHash: hashValue) { attestation, error in
                if let attestationError = error as? DCError {
                    switch attestationError.code {
                    case .invalidKey:
                        if !KeychainManager.shared.deleteKeyId(){
                            print("Couldn't delete App Attest Key ID")
                        }else if tryCount == 0 { // try to generate new key after deleting old one
                            self.certifyAppAttestKey(challenge: challenge, tryCount: tryCount+1, completion: completion)
                            return
                        }
                    default:
                        break
                    }
                    completion(nil, attestationError.code)
                    return
                }
                guard let attestation = attestation else {
                    completion(nil, .unknownSystemFailure)
                    return
                }
                completion(attestation.base64EncodedString(), nil)
            }
        }
    }

    func generateRandomBytes() -> Data? {

        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
}

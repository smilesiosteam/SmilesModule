import DeviceCheck

@objc public final class DeviceAppCheck: NSObject {
    
     @objc public static var shared = DeviceAppCheck()

     @objc public func reset() {
        _ = KeychainManager.shared.deleteKeyId()
    }
    public func getSecurityData(_ completion:@escaping(_ deviceCheckToken:String?, _ attestation:String?, _ challange:String?, _ error:DCError.Code?) -> Void) {
        if #available(iOS 14.0, *), DCAppAttestService.shared.isSupported {
            guard let challangeData = AppAttestor.shared.generateRandomBytes() else {
                completion(nil,nil,nil,.unknownSystemFailure)
                return
            }
            AppAttestor.shared.certifyAppAttestKey(challenge: challangeData, tryCount: 0) { attest, error in
                if let error = error {
                    completion(nil, nil, nil, error)
                }else if let attest = attest {
                    completion(nil, attest, challangeData.base64EncodedString(), nil)
                }else{
                    completion(nil, nil, nil, .unknownSystemFailure)
                }
            }
        }else if #available(iOS 11.0, *), DCDevice.current.isSupported {
            DCDevice.current.generateToken { data, error in
                if let data = data {
                    completion(data.base64EncodedString(),nil,nil,nil)
                }else {
                    completion(nil, nil, nil, .unknownSystemFailure)
                }
            }
        }else{
            completion(nil, nil, nil, .unknownSystemFailure)
        }
    }
    public func isSupported() -> Bool {
        if #available(iOS 14.0, *), DCAppAttestService.shared.isSupported {
           return true
        }else if #available(iOS 11.0, *), DCDevice.current.isSupported {
            return true
        }else{
            return false
        }
    }
}

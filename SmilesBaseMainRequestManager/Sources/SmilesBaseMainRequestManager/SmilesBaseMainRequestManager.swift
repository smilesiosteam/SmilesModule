//
//  File.swift
//
//
//  Created by Abdul Rehman Amjad on 21/02/2023.
//

import Foundation
import SmilesUtilities

@objc public class SmilesBaseMainRequestManager: NSObject {
    
    public static let shared = SmilesBaseMainRequestManager()
    private let serialQueue = DispatchQueue(label: "com.smiles.smilesSerialQueue", attributes: .concurrent)
    private var _baseMainRequestConfigs: SmilesBaseMainRequest?
    
    public var baseMainRequestConfigs: SmilesBaseMainRequest? {
        var value: SmilesBaseMainRequest?
        serialQueue.sync {
            value = _baseMainRequestConfigs
        }
        return value
    }
    
    @objc public func setupBaseRequestConfigs(additionalInfo: [BaseMainResponseAdditionalInfo], appVersion: String?, authToken: String?, channel: String?, deviceId: String?, handsetModel: String?, imsi: String?, isGpsEnabled: Bool = false, isNotificationEnabled: Bool = false, langauge: String?, msisdn: String?, osVersion: String?, token: String?, hashId: String?, deviceHashId: String?, userInfo: AppUserInfo?, deviceHashIdV2: String?) {
        
        let newValue = SmilesBaseMainRequest(additionalInfo: additionalInfo, appVersion: appVersion, authToken: authToken, channel: channel, deviceId: deviceId, handsetModel: handsetModel, imsi: imsi, isGpsEnabled: isGpsEnabled, isNotificationEnabled: isNotificationEnabled, langauge: langauge, msisdn: msisdn, osVersion: osVersion, token: token, hashId: hashId, deviceHashId: deviceHashId, userInfo: userInfo, deviceHashIdV2: deviceHashIdV2)
        changeBaseMainRequestConfigsValue(newValue)
    }
    
    private func changeBaseMainRequestConfigsValue(_  value: SmilesBaseMainRequest?) {
        serialQueue.async(flags: .barrier)  { [weak self] in
            self?._baseMainRequestConfigs =  value
        }
    }
    
    @objc public func getConfigsAsDictionary() -> [String: Any] {
        guard let configs = _baseMainRequestConfigs else { return [:] }
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(configs))) as? [String: Any] ?? [:]
    }
    
}

//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 10/03/2023.
//

import Foundation

protocol BaseMainRequestable {
     func updateValue(baseRequest : SmilesBaseMainRequest)
}

extension BaseMainRequestable {

    func updateValue(baseRequest : SmilesBaseMainRequest) {
        guard let configs = SmilesBaseMainRequestManager.shared.baseMainRequestConfigs else { return }
        baseRequest.additionalInfo = configs.additionalInfo
        baseRequest.appVersion = configs.appVersion
        baseRequest.authToken = configs.authToken
        baseRequest.channel = configs.channel
        baseRequest.deviceId = configs.deviceId
        baseRequest.handsetModel = configs.handsetModel
        baseRequest.imsi = configs.imsi
        baseRequest.isGpsEnabled = configs.isGpsEnabled
        baseRequest.isNotificationEnabled = configs.isNotificationEnabled
        baseRequest.lang = configs.lang
        baseRequest.msisdn = configs.msisdn
        baseRequest.osVersion = configs.osVersion
        baseRequest.token = configs.token
        baseRequest.hashId = configs.hashId
        baseRequest.deviceHashId = configs.deviceHashId
        baseRequest.userInfo = configs.userInfo
        baseRequest.deviceHashIdV2 = configs.deviceHashIdV2
    }
}


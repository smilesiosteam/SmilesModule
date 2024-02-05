//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 21/02/2023.
//

import Foundation
import SmilesUtilities

open class SmilesBaseMainRequest : BaseMainRequestable, Codable {
    
    public var additionalInfo: [BaseMainResponseAdditionalInfo]?
    public var appVersion : String?
    public var authToken : String?
    public var channel : String?
    public var deviceId : String?
    public var handsetModel : String?
    public var imsi : String?
    public var isGpsEnabled : Bool?
    public var isNotificationEnabled : Bool?
    @objc public var lang : String?
    @objc public var msisdn : String?
    public var osVersion : String?
    public var token : String?
    public var hashId : String?
    public var deviceHashId : String?
    public var userInfo : AppUserInfo?
    public var deviceHashIdV2 : String?
    
    enum CodingKeys: String, CodingKey {
        case additionalInfo
        case appVersion
        case authToken
        case channel
        case deviceId
        case handsetModel
        case imsi
        case isGpsEnabled
        case isNotificationEnabled
        case lang
        case msisdn
        case osVersion
        case token
        case hashId
        case deviceHashId
        case userInfo
        case deviceHashIdV2
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        updateValue(baseRequest: self)
        try container.encode(self.additionalInfo, forKey: .additionalInfo)
        try container.encodeIfPresent(self.appVersion, forKey: .appVersion)
        try container.encodeIfPresent(self.authToken, forKey: .authToken)
        try container.encodeIfPresent(self.channel, forKey: .channel)
        try container.encodeIfPresent(self.deviceId, forKey: .deviceId)
        try container.encodeIfPresent(self.handsetModel, forKey: .handsetModel)
        try container.encodeIfPresent(self.imsi, forKey: .imsi)
        try container.encodeIfPresent(self.isGpsEnabled, forKey: .isGpsEnabled)
        try container.encodeIfPresent(self.isNotificationEnabled, forKey: .isNotificationEnabled)
        try container.encodeIfPresent(self.lang, forKey: .lang)
        try container.encodeIfPresent(self.msisdn, forKey: .msisdn)
        try container.encodeIfPresent(self.osVersion, forKey: .osVersion)
        try container.encodeIfPresent(self.token, forKey: .token)
        try container.encodeIfPresent(self.hashId, forKey: .hashId)
        try container.encodeIfPresent(self.deviceHashId, forKey: .deviceHashId)
        try container.encodeIfPresent(self.userInfo, forKey: .userInfo)
        try container.encodeIfPresent(self.deviceHashIdV2, forKey: .deviceHashIdV2)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        additionalInfo = try values.decode([BaseMainResponseAdditionalInfo].self, forKey: .additionalInfo)
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
        authToken = try values.decodeIfPresent(String.self, forKey: .authToken)
        channel = try values.decodeIfPresent(String.self, forKey: .channel)
        deviceId = try values.decodeIfPresent(String.self, forKey: .deviceId)
        handsetModel = try values.decodeIfPresent(String.self, forKey: .handsetModel)
        imsi = try values.decodeIfPresent(String.self, forKey: .imsi)
        isGpsEnabled = try values.decodeIfPresent(Bool.self, forKey: .isGpsEnabled)
        isNotificationEnabled = try values.decodeIfPresent(Bool.self, forKey: .isNotificationEnabled)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        msisdn = try values.decodeIfPresent(String.self, forKey: .msisdn)
        osVersion = try values.decodeIfPresent(String.self, forKey: .osVersion)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        hashId = try values.decodeIfPresent(String.self, forKey: .hashId)
        deviceHashId = try values.decodeIfPresent(String.self, forKey: .deviceHashId)
        userInfo = try values.decode(AppUserInfo.self, forKey: .userInfo)
        deviceHashIdV2 = try values.decodeIfPresent(String.self, forKey: .deviceHashIdV2)
        
    }
    
    init(additionalInfo: [BaseMainResponseAdditionalInfo], appVersion: String?, authToken: String?, channel: String?, deviceId: String?, handsetModel: String?, imsi: String?, isGpsEnabled: Bool?, isNotificationEnabled: Bool?, langauge: String?, msisdn: String?, osVersion: String?, token: String?, hashId: String?, deviceHashId: String?, userInfo: AppUserInfo?, deviceHashIdV2: String?) {
        
        self.additionalInfo = additionalInfo
        self.appVersion = appVersion
        self.authToken = authToken
        self.channel = channel
        self.deviceId = deviceId
        self.handsetModel = handsetModel
        self.imsi = imsi
        self.isGpsEnabled = isGpsEnabled
        self.isNotificationEnabled = isNotificationEnabled
        self.lang = langauge
        self.msisdn = msisdn
        self.osVersion = osVersion
        self.token = token
        self.hashId = hashId
        self.deviceHashId = deviceHashId
        self.userInfo = userInfo
        self.deviceHashIdV2 = deviceHashIdV2
        
    }
    
    public init() {}
    
}

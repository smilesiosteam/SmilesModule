//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 27/07/2023.
//

import Foundation

public struct GetTopAdsResponseModel: Codable {
    
    public var extTransactionId: String?
    public var sliderTimeout: Double?
    public var adsDto: [TopAdsDto]?
    
    public enum CodingKeys: String, CodingKey {
        case extTransactionId
        case sliderTimeout, adsDto
    }
    
    public init() {
        
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        extTransactionId = try values.decodeIfPresent(String.self, forKey: .extTransactionId)
        sliderTimeout = try values.decodeIfPresent(Double.self, forKey: .sliderTimeout)
        adsDto = try values.decodeIfPresent([TopAdsDto].self, forKey: .adsDto)
    }
    
    public struct TopAdsDto: Codable {
        public let position: Int?
        public let ads: [TopAd]?
        
        public enum CodingKeys: String, CodingKey {
            case position
            case ads
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            position = try values.decodeIfPresent(Int.self, forKey: .position)
            ads = try values.decodeIfPresent([TopAd].self, forKey: .ads)
        }
        
        public struct TopAd: Codable {
            public let adId: Int?
            public let adImageUrl: String?
            public let externalWebUrl: String?
            public var adsJsonAnimationUrl: String?
            public let sourceClick: String?
            
            public enum CodingKeys: String, CodingKey {
                case adId = "adId"
                case adImageUrl = "adImageUrl"
                case externalWebUrl = "externalWebUrl"
                case adsJsonAnimationUrl = "adsJsonAnimationUrl"
                case sourceClick
            }
            
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                adId = try values.decodeIfPresent(Int.self, forKey: .adId)
                adImageUrl = try values.decodeIfPresent(String.self, forKey: .adImageUrl)
                externalWebUrl = try values.decodeIfPresent(String.self, forKey: .externalWebUrl)
                adsJsonAnimationUrl = try values.decodeIfPresent(String.self, forKey: .adsJsonAnimationUrl)
                sourceClick = try values.decodeIfPresent(String.self, forKey: .sourceClick)
            }
        }
    }
}

//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 17/11/2023.
//

public class SWGoogleResult : Codable {

    public let addressComponents : [SWGoogleAddressComponent]?
    public let formattedAddress : String?
    public let geometry : SWGoogleGeometry?
    public let placeId : String?
    public let types : [String]?


    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry = "geometry"
        case placeId = "place_id"
        case types = "types"
    }
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressComponents = try values.decodeIfPresent([SWGoogleAddressComponent].self, forKey: .addressComponents)
        formattedAddress = try values.decodeIfPresent(String.self, forKey: .formattedAddress)
        geometry = try SWGoogleGeometry(from: decoder)
        placeId = try values.decodeIfPresent(String.self, forKey: .placeId)
        types = try values.decodeIfPresent([String].self, forKey: .types)
//        try super.init(from: decoder)
     }


}

//
//  User.swift
//  user-login-test
//
//  Created by John Paulo on 7/6/22.
//

import Foundation

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: UserAddress
    var phone: String
    var website: String
    var company: UserCompany
}

struct UserAddress: Decodable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var coordinates: (lat: String, lng: String)
    
    enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode
        case coordinates = "geo"
    }
    
    enum CoordinatesKeys: String, CodingKey {
        case lat, lng
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(String.self, forKey: .street)
        suite = try container.decode(String.self, forKey: .suite)
        city = try container.decode(String.self, forKey: .city)
        zipcode = try container.decode(String.self, forKey: .zipcode)
        
        let coordinatesContainer = try container.nestedContainer(keyedBy: CoordinatesKeys.self, forKey: .coordinates)
        let lat = try coordinatesContainer.decode(String.self, forKey: .lat)
        let lng = try coordinatesContainer.decode(String.self, forKey: .lng)
        
        coordinates = (lat: lat, lng: lng)
    }
}

struct UserCompany: Decodable {
    var name: String
    var catchPhrase: String
    var bs: String
}

//
//  HarvestBid.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Harvest: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let rate: Int
    let price: Int
    let date: String
    let location: CLLocationCoordinate2D?
    let description: String
    var status: HarvestStatus
    
    enum CodingKeys: String, CodingKey {
        case name
        case rate
        case price
        case date
        case location
        case description
        case status
    }
    
    init(
        name: String,
        rate: Int,
        price: Int,
        date: String,
        location: CLLocationCoordinate2D?,
        description: String,
        status: HarvestStatus
    ) {
        self.name = name
        self.rate = rate
        self.price = price
        self.date = date
        self.location = location
        self.description = description
        self.status = status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        rate = try container.decode(Int.self, forKey: .rate)
        price = try container.decode(Int.self, forKey: .price)
        date = try container.decode(String.self, forKey: .date)
        description = try container.decode(String.self, forKey: .description)
        status = try container.decode(HarvestStatus.self, forKey: .status)
        
        if let locationDict = try? container.decodeIfPresent([String: Double].self, forKey: .location) {
            if let lat = locationDict["latitude"], let lon = locationDict["longitude"] {
                location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            } else {
                location = nil
            }
        } else {
            location = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(rate, forKey: .rate)
        try container.encode(price, forKey: .price)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(status, forKey: .status)
        
        if let location = location {
            let locationDict: [String: Double] = [
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
            try container.encode(locationDict, forKey: .location)
        }
    }
}


enum HarvestStatus: String, Codable {
    case successful
    case unsuccessful
    case pending
}

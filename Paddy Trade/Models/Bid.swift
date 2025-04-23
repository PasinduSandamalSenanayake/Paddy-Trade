//
//  Bid.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI

struct Bid: Identifiable, Codable {
    var id = UUID() 
    let imageName: String
    let name: String
    let location: String
    let price: Int
    let totalWeight: Int
    let date: String
    let latitude: Double
    let longitude: Double
    var status: BidStatus? = .pending

    enum CodingKeys: String, CodingKey {
        case imageName, name, location, price, totalWeight, date, latitude, longitude, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        imageName = try container.decode(String.self, forKey: .imageName)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        price = try container.decode(Int.self, forKey: .price)
        totalWeight = try container.decode(Int.self, forKey: .totalWeight)
        date = try container.decode(String.self, forKey: .date)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)

        if let statusString = try? container.decode(String.self, forKey: .status) {
            status = BidStatus(rawValue: statusString)
        } else {
            status = .pending
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(imageName, forKey: .imageName)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
        try container.encode(price, forKey: .price)
        try container.encode(totalWeight, forKey: .totalWeight)
        try container.encode(date, forKey: .date)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(status?.rawValue ?? "Pending", forKey: .status)
    }
}


struct FirebaseBid: Codable {
    var imageName: String
    var name: String
    var location: String
    var price: Int
    var totalWeight: Int
    var date: String
    var latitude: Double
    var longitude: Double
    var status: String
    var userBid: Double
    var totalPrice: Double
    var timestamp: Date
    var userId: String
}


enum BidStatus: String, CaseIterable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}



//
//  Bid.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI

struct Bid: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let location: String
    let price: Int
    let totalWeight: Int
    let date: String
    let latitude: Double
    let longitude: Double
    var status: BidStatus? = .pending

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
}


enum BidStatus: String, CaseIterable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}



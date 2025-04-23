//
//  HarvestBid.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import Foundation
import CoreLocation

struct Harvest: Identifiable {
    let id = UUID()
    let name: String               // e.g. "Mr. Nimal Perera"
    let rate: Int                 // e.g. success rate or bid rate
    let price: Int                // per kg
    let date: String              // for display
    let location: CLLocationCoordinate2D?  // for map
    let description: String       // extra info or notes
    let status: HarvestStatus     // new: status for analysis
}

enum HarvestStatus: String, Codable {
    case successful
    case unsuccessful
    case pending
}

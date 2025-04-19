//
//  HarvestBid.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import Foundation

struct HarvestBid: Identifiable {
    let id = UUID()
    let name: String
    let rate: Int
    let price: Int
    let date: String
}

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
}

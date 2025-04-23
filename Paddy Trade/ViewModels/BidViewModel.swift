//
//  BidViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import Foundation
import FirebaseFirestore

class BidDetailViewModel: ObservableObject {
    @Published var userBid: String = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String? = nil

    func placeBid(for bid: Bid, completion: @escaping (Bool) -> Void) {
        guard let userBidAmount = Double(userBid) else {
            errorMessage = "Invalid bid amount."
            completion(false)
            return
        }

        let totalPrice = userBidAmount * Double(bid.totalWeight)
        let db = Firestore.firestore()

        let bidData = FirebaseBid(
            imageName: bid.imageName,
            name: bid.name,
            location: bid.location,
            price: bid.price,
            totalWeight: bid.totalWeight,
            date: bid.date,
            latitude: bid.latitude,
            longitude: bid.longitude,
            status: bid.status?.rawValue ?? "Pending",
            userBid: userBidAmount,
            totalPrice: totalPrice,
            timestamp: Date()
        )

        do {
            let encodedData = try Firestore.Encoder().encode(bidData)
            isSubmitting = true
            db.collection("userBids").addDocument(data: encodedData) { error in
                DispatchQueue.main.async {
                    self.isSubmitting = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
            completion(false)
        }
    }
}


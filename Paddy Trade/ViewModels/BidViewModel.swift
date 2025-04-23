//
//  BidViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class BidDetailViewModel: ObservableObject {
    @Published var userBid: String = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String? = nil
    @Published var bids: [Bid] = []
    @Published var isLoading = false
    @Published var error: String?

       private let db = Firestore.firestore()
    
    
    func placeBid(for bid: Bid, completion: @escaping (Bool) -> Void) {
        guard let userBidAmount = Double(userBid) else {
            errorMessage = "Invalid bid amount."
            completion(false)
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User not logged in."
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
            timestamp: Date(),
            userId: currentUser.uid // 👈 Set user ID
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
    
    
    func fetchAllOtherBids() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            self.error = "User not logged in"
            return
        }

        isLoading = true
        db.collection("userBids")
            .whereField("userId", isNotEqualTo: currentUserId)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.error = error.localizedDescription
                        return
                    }

                    self.bids = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: Bid.self)
                    } ?? []
                }
            }
    }

    
    func fetchUserBids() {
            guard let userId = Auth.auth().currentUser?.uid else {
                self.error = "User not logged in"
                return
            }

            isLoading = true
            db.collection("userBids")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { snapshot, error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let error = error {
                            self.error = error.localizedDescription
                            return
                        }

                        self.bids = snapshot?.documents.compactMap { doc in
                            try? doc.data(as: Bid.self)
                        } ?? []
                    }
                }
        }
    
}


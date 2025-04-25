//
//  SampleDataManager.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import Foundation
import FirebaseFirestore
import CoreLocation


class SampleDataManager {
    static let shared = SampleDataManager()
    
    private let db = Firestore.firestore()
    
    func addSampleBidsIfNeeded() {
        checkAndSeedSampleBids()
        checkAndSeedSampleHarvests()
    }
    
    private func checkAndSeedSampleBids() {
        let bidsRef = db.collection("userBids")
        bidsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user bids: \(error.localizedDescription)")
                return
            }
            
            if querySnapshot?.isEmpty ?? true {
                self.seedSampleBids()
            } else {
                print("Bids already exist in Firestore. Skipping seeding.")
            }
        }
    }
    
    private func checkAndSeedSampleHarvests() {
        let harvestsRef = db.collection("harvests")
        harvestsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching harvests: \(error.localizedDescription)")
                return
            }
            
            if querySnapshot?.isEmpty ?? true {
                self.seedSampleHarvests()
            } else {
                print("Harvests already exist in Firestore. Skipping seeding.")
            }
        }
    }
    
    private func seedSampleBids() {
        let sampleUsers = (1...10).map { "user_\($0)" }
        let sampleBids: [FirebaseBid] = sampleUsers.map { userId in
            FirebaseBid(
                imageName: "paddy_image",
                name: "Samba Rice",
                location: ["Anuradhapura", "Polonnaruwa", "Kurunegala", "Kandy", "Matale"].randomElement()!,
                price: Int.random(in: 120...180),
                totalWeight: Int.random(in: 100...500),
                date: "2025-04-\(Int.random(in: 10...25))",
                latitude: Double.random(in: 6.0...10.0),
                longitude: Double.random(in: 79.0...81.0),
                status: "Pending",
                userBid: 0.0,
                totalPrice: 0.0,
                timestamp: Date(),
                userId: userId
            )
        }
        
        for bid in sampleBids {
            do {
                let encoded = try Firestore.Encoder().encode(bid)
                print("Encoding succeeded for user \(bid.userId)")
                
                db.collection("userBids").addDocument(data: encoded) { error in
                    if let error = error {
                        print("Firestore write failed for user \(bid.userId): \(error.localizedDescription)")
                    } else {
                        print("Successfully added bid for user: \(bid.userId)")
                    }
                }
            } catch {
                print("Failed to encode sample bid: \(error.localizedDescription)")
            }
        }
    }
    
    private func seedSampleHarvests() {
        let sampleHarvests: [Harvest] = (1...10).map { index in
            Harvest(
                name: "Farmer \(index)",
                rate: Int.random(in: 70...95),
                price: Int.random(in: 120...200),
                date: "2025-04-\(Int.random(in: 10...25))",
                location: CLLocationCoordinate2D(latitude: Double.random(in: 6.0...10.0), longitude: Double.random(in: 79.0...81.0)),
                description: "This is a sample harvest from Farmer \(index).",
                status: .pending
            )
        }
        
        for harvest in sampleHarvests {
            do {
                let encoded = try Firestore.Encoder().encode(harvest)
                print("Encoding succeeded for harvest \(harvest.name)")
                
                db.collection("harvests").addDocument(data: encoded) { error in
                    if let error = error {
                        print("Firestore write failed for harvest \(harvest.name): \(error.localizedDescription)")
                    } else {
                        print("Successfully added harvest for \(harvest.name)")
                    }
                }
            } catch {
                print("Failed to encode sample harvest: \(error.localizedDescription)")
            }
        }
    }
}

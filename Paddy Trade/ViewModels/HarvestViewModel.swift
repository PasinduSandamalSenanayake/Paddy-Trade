//
//  HarvestViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class HarvestViewModel: ObservableObject {
    
    @Published var harvests: [Harvest] = []
    @Published var paddyType = "Samba Paddy Yield"
    @Published var totalYield = ""
    @Published var basePrice = ""
    @Published var description = "Welcome to PaddyTrade, your direct gateway to a seamless agricultural trading experience! Designed for simplicity and security."
    @Published var selectedLocation: CLLocationCoordinate2D? = nil
    @Published var successfulCount = 0
    @Published var unsuccessfulCount = 0
    @Published var pendingCount = 0

    
    private var db = Firestore.firestore()

    func addHarvest() {
        guard let yield = Int(totalYield), yield > 0 else {
            print("Invalid total yield")
            return
        }
        
        guard let price = Int(basePrice), price > 0 else {
            print("Invalid price")
            return
        }
        
        let newHarvest = Harvest(
            name: "Mr. Nimal Perera",
            rate: 85,
            price: price,
            date: getCurrentDate(),
            location: selectedLocation,
            description: description,
            status: .pending
        )
        
        saveHarvestToFirestore(newHarvest)
        
        resetFields()
    }
    
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date())
    }
    
    private func resetFields() {
        totalYield = ""
        basePrice = ""
        description = ""
        selectedLocation = nil
    }
    
    private func saveHarvestToFirestore(_ harvest: Harvest) {
        do {
            let newHarvest = harvest
            let ref = try db.collection("harvests").addDocument(from: newHarvest) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Harvest successfully added!")
                    self.fetchHarvests()
                }
            }
        } catch {
            print("Error saving harvest: \(error.localizedDescription)")
        }
    }

    
    
   

    func fetchHarvests() {
        db.collection("harvests")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching harvests: \(error)")
                    return
                }

                guard let snapshot = snapshot else { return }

                self?.harvests = snapshot.documents.compactMap { doc in
                    var harvest = try? doc.data(as: Harvest.self)
                    harvest?.id = doc.documentID  // Assign the document ID
                    return harvest
                }
                
                self?.calculateHarvestStats()
            }
    }

        
        func calculateHarvestStats() {
            successfulCount = harvests.filter { $0.status == .successful }.count
            unsuccessfulCount = harvests.filter { $0.status == .unsuccessful }.count
            pendingCount = harvests.filter { $0.status == .pending }.count
        }
    
    

    func acceptHarvest(_ harvest: Harvest) {
        guard let id = harvest.id else { return }

        let docRef = db.collection("harvests").document(id)

        docRef.updateData([
            "status": HarvestStatus.successful.rawValue
        ]) { error in
            if let error = error {
                print("Error updating harvest status: \(error.localizedDescription)")
            } else {
                print("Harvest successfully accepted!")

                DispatchQueue.main.async {
                    if let index = self.harvests.firstIndex(where: { $0.id == id }) {
                        var updated = self.harvests[index]
                        updated.status = .successful
                        self.harvests[index] = updated
                        self.calculateHarvestStats()
                    }
                }
            }
        }
    }


}

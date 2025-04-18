//
//  BidDetailView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import Charts

struct BidAnalyzingView: View {
    let bidData: [Bid] = [
        Bid(imageName: "paddy_image", name: "Samba", location: "Thalawa", price: 125, totalWeight: 1545, date: "2025/03/15", latitude: 8.1234, longitude: 80.1234, status: .accepted),
        Bid(imageName: "paddy_image", name: "Nadu", location: "Kekirawa", price: 118, totalWeight: 1000, date: "2025/03/10", latitude: 8.2345, longitude: 80.2345, status: .rejected),
        Bid(imageName: "paddy_image", name: "Samba", location: "Anuradhapura", price: 127, totalWeight: 1100, date: "2025/03/13", latitude: 8.3456, longitude: 80.3456, status: .pending),
        Bid(imageName: "paddy_image", name: "Samba", location: "Thalawa", price: 125, totalWeight: 1545, date: "2025/03/15", latitude: 8.1234, longitude: 80.1234, status: .accepted),
        Bid(imageName: "paddy_image", name: "Nadu", location: "Kekirawa", price: 118, totalWeight: 1000, date: "2025/03/10", latitude: 8.2345, longitude: 80.2345, status: .rejected),
        Bid(imageName: "paddy_image", name: "Samba", location: "Anuradhapura", price: 127, totalWeight: 1100, date: "2025/03/13", latitude: 8.3456, longitude: 80.3456, status: .pending)
    ]

    var statusCounts: [BidStatus: Int] {
        Dictionary(grouping: bidData, by: { $0.status ?? .pending }).mapValues { $0.count }
    }
    
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack{
                        VStack(alignment:.leading){
                            HStack(spacing: 2){
                                Text("Bid")
                                    .foregroundColor(.black)
                                    .opacity(0.8)
                                Text("Analysis")
                                    .foregroundColor(.splashGreen)

                            }
                                .font(.system(size: 30, weight: .bold))
                            Text("Bid Status Overview")

                        }
                        Spacer()
                    }
                    
                        

                    Chart {
                        ForEach(BidStatus.allCases, id: \.self) { status in
                            if let count = statusCounts[status] {
                                SectorMark(
                                    angle: .value("Bids", count),
                                    innerRadius: .ratio(0.6),
                                    angularInset: 1
                                )
                                .foregroundStyle(by: .value("Status", status.rawValue))
                                .cornerRadius(4)
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)
                    .chartLegend(position: .bottom)

                    Divider()

                    Text("Bid History")
                        .font(.headline)
                        .padding(.top)

                    ForEach(bidData) { bid in
                        BidHistoryCardView(bid: bid)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.splashGreen)
        })    }
}




struct BidHistoryCardView: View {
    let bid: Bid

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.splashGreen)
                Text(bid.name)
                    .font(.headline)
                Spacer()
                Text(bid.status?.rawValue ?? "Pending")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.vertical,5)
                    .frame(width: 100)
                    .background(statusColor(bid.status))
                    .cornerRadius(100)
            }

            HStack{
                Text("Location:")
                    .font(.subheadline)
                    .opacity(0.7)
                Text("\(bid.location)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            
            HStack {
                Text("Price: Rs \(bid.price)/kg")
                Spacer()
                Text("Total: \(bid.totalWeight) kg")
            }
            .font(.footnote)

            Text("Date: \(bid.date)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    func statusColor(_ status: BidStatus?) -> Color {
        switch status {
        case .accepted: return .splashGreen
        case .rejected: return .red
        case .pending: return .orange
        case .none: return .gray
        }
    }
}


#Preview {
    BidAnalyzingView()
}

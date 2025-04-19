//
//  HarvestAnalyzingView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import SwiftUI
import Charts

struct HarvestAnalyzingView: View {
    let successful = 21
    let unsuccessful = 18
    let pending = 11
    @Environment(\.presentationMode) var presentationMode
    
    var total: Int { successful + unsuccessful + pending }
    var successRate: Int {
        guard total > 0 else { return 0 }
        return Int((Double(successful) / Double(total)) * 100)
    }
    
    let bids: [HarvestBid] = [
        HarvestBid(name: "Mr. Nimal Perera", rate: 35, price: 122, date: "2025/03/10"),
        HarvestBid(name: "Ms. Sanduni Jayasuriya", rate: 38, price: 130, date: "2025/03/12"),
        HarvestBid(name: "Mr. Amal Rajapaksha", rate: 37, price: 125, date: "2025/03/14"),
        HarvestBid(name: "Mrs. Tharaka Silva", rate: 34, price: 129, date: "2025/03/16")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Text("Harvest")
                            .foregroundColor(.black)
                        + Text(" Analysis")
                            .foregroundColor(.splashGreen)
                    }
                    .font(.system(size: 30, weight: .bold))
                    
                    ZStack {
                        Chart {
                            SectorMark(angle: .value("Successful", successful), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.blue)
                            SectorMark(angle: .value("Unsuccessful", unsuccessful), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.red)
                            SectorMark(angle: .value("Pending", pending), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.gray)
                        }
                        .frame(height: 200)
                        
                        Text("\(successRate)%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Circle().fill(Color.blue).frame(width: 10, height: 10)
                            Text("Successful Harvests - \(successful)")
                        }
                        HStack {
                            Circle().fill(Color.red).frame(width: 10, height: 10)
                            Text("Unsuccessful Harvests - \(unsuccessful)")
                        }
                        HStack {
                            Circle().fill(Color.gray).frame(width: 10, height: 10)
                            Text("Pending Harvests - \(pending)")
                        }
                    }
                    .font(.subheadline)
                    
                    Divider()
                    
                    Text("Bids For Harvest")
                        .font(.headline)
                    
                    ForEach(bids) { bid in
                        HarvestBidCard(bid: bid)
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
        })
    }
    
    
}



struct HarvestBidCard: View {
    let bid: HarvestBid
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(bid.name)
                    .font(.headline)
                Spacer()
                Text("Rs \(bid.price)")
                    .foregroundColor(.splashGreen)
                    .font(.headline)
                Text("/ per kg")
                    .font(.caption)
            }
            
            Text("Successful Rate - \(bid.rate)%")
                .foregroundColor(.blue)
                .font(.subheadline)
            
            HStack {
                Image(systemName: "calendar")
                Text(bid.date)
                    .font(.caption)
                Spacer()
                Button("Accept") {
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.splashGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}


#Preview{
    HarvestAnalyzingView()
}

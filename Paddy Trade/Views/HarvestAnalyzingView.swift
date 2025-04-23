//
//  HarvestAnalyzingView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import SwiftUI
import Charts

struct HarvestAnalyzingView: View {
    @StateObject var viewModel = HarvestViewModel()
    
    var total: Int {
        viewModel.successfulCount + viewModel.unsuccessfulCount + viewModel.pendingCount
    }
    
    var successRate: Int {
        guard total > 0 else { return 0 }
        return Int((Double(viewModel.successfulCount) / Double(total)) * 100)
    }

    @Environment(\.presentationMode) var presentationMode

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
                            SectorMark(angle: .value("Successful", viewModel.successfulCount), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.blue)
                            SectorMark(angle: .value("Unsuccessful", viewModel.unsuccessfulCount), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.red)
                            SectorMark(angle: .value("Pending", viewModel.pendingCount), innerRadius: .ratio(0.6))
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
                            Text("Successful Harvests - \(viewModel.successfulCount)")
                        }
                        HStack {
                            Circle().fill(Color.red).frame(width: 10, height: 10)
                            Text("Unsuccessful Harvests - \(viewModel.unsuccessfulCount)")
                        }
                        HStack {
                            Circle().fill(Color.gray).frame(width: 10, height: 10)
                            Text("Pending Harvests - \(viewModel.pendingCount)")
                        }
                    }
                    .font(.subheadline)
                    
                    Divider()
                    
                    Text("Bids For Harvest")
                        .font(.headline)
                    
                    ForEach(viewModel.harvests) { bid in
                        HarvestBidCard(bid: bid, viewModel: viewModel)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchHarvests() // Fetch data when the view appears
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
    let bid: Harvest
    @ObservedObject var viewModel: HarvestViewModel

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
                    viewModel.acceptHarvest(bid)
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

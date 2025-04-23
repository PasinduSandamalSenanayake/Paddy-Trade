//
//  BidDetailView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import Charts

import SwiftUI
import Charts

struct BidAnalyzingView: View {
    @StateObject private var viewModel = BidDetailViewModel()
    @Environment(\.presentationMode) var presentationMode

    var pending: Int {
        viewModel.bids.filter { $0.status == .pending }.count
    }

    var accepted: Int {
        viewModel.bids.filter { $0.status == .accepted }.count
    }

    var rejected: Int {
        viewModel.bids.filter { $0.status == .rejected }.count
    }

    var total: Int {
        pending + accepted + rejected
    }

    var acceptedPercentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(accepted) / Double(total)) * 100)
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(spacing: 2) {
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

                    ZStack {
                        Chart {
                            SectorMark(angle: .value("Pending", pending), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.blue)
                            SectorMark(angle: .value("Accepted", accepted), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.red)
                            SectorMark(angle: .value("Rejected", rejected), innerRadius: .ratio(0.6))
                                .foregroundStyle(Color.gray)
                        }
                        .frame(height: 200)

                        Text("\(acceptedPercentage)%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Circle().fill(Color.blue).frame(width: 10, height: 10)
                            Text("Successful Bids - \(accepted)")
                        }
                        HStack {
                            Circle().fill(Color.red).frame(width: 10, height: 10)
                            Text("Unsuccessful Bids - \(rejected)")
                        }
                        HStack {
                            Circle().fill(Color.gray).frame(width: 10, height: 10)
                            Text("Pending Bids - \(pending)")
                        }
                    }
                    .font(.subheadline)

                    Divider()

                    Text("Bid History")
                        .font(.headline)
                        .padding(.top)

                    if viewModel.isLoading {
                        ProgressView()
                    } else if let error = viewModel.error {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else if viewModel.bids.isEmpty {
                        Text("No bids found.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.bids) { bid in
                            BidHistoryCardView(bid: bid)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchUserBids()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.splashGreen)
        })
    }
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

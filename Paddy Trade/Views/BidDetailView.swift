//
//  BidDetailView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI


import SwiftUI
import MapKit

struct BidDetailView: View {
    let bid: Bid
    @State private var userBid: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedBidLocation: Bid? = nil
    @State private var showMap = false
    var totalPrice: Double {
        (Double(userBid) ?? 0) * Double(bid.totalWeight)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Image(bid.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Place Your Bid")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.splashGreen)
                        
                        HStack {
                            Text(bid.name)
                                .font(.headline)
                            Spacer()
                            Text("Rs \(bid.price) / per kg")
                                .foregroundColor(.splashGreen)
                                .bold()
                        }
                        
                        HStack(spacing: 5) {
                            Label("\(bid.location)", systemImage: "mappin.circle")
                                .foregroundColor(.gray)
                            Button {
                                self.showMap = true
                            } label: {
                                Text("Open in map")
                                    .foregroundColor(.lightGreen)
                                    .bold()
                            }
                            
                            Spacer()
                            Text("\(bid.totalWeight) kg")
                                .foregroundColor(.gray)
                        }
                        
                        Label("Harvested Date - \(bid.date)", systemImage: "calendar")
                            .foregroundColor(.gray)
                        
                        Text("Description")
                            .font(.headline)
                            .padding(.top,15)
                        Text("Welcome to PaddyTrade, your direct gateway to a seamless agricultural trading experience!")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom,15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Place a Bid per kg")
                            TextField("Enter your bid", text: $userBid)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            Text("Calculate the total cost")
                            Text("Rs \(String(format: "%.2f", totalPrice))")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                            NotificationManager.shared.requestAuthorization()
                            NotificationManager.shared.scheduleNotification(
                                title: "Bid Place Sucess!",
                                body: "You have placed bid sucessfully",
                                afterSeconds: 1
                            )
                        } label: {
                            Text("Place The Bid")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.splashGreen)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        
                        
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.splashGreen)
        })
        .fullScreenCover(isPresented: $showMap) {
            MapDisplayView(bid: bid)
        }
    }
}



#Preview {
    BidDetailView(bid: .init(imageName: "paddy_image", name: "Samba Paddy", location: "Anuradhapura", price: 125, totalWeight: 1545, date: "2025/03/15", latitude: 8.3114, longitude: 80.4037))
}

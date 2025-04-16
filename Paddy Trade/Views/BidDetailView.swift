//
//  BidDetailView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI


struct BidDetailView: View {
    let bid: Bid
    @State private var userBid: String = ""
    @Environment(\.presentationMode) var presentationMode

    var totalPrice: Double {
        (Double(userBid) ?? 0) * Double(bid.totalWeight)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Image(bid.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Place a Your Bid")
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
                    
                    HStack(spacing: 3) {
                        Label("\(bid.location)", systemImage: "mappin.circle")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Total - \(bid.totalWeight) kg")
                            .foregroundColor(.gray)
                    }
                    
                    Label("Harvested Date - \(bid.date)", systemImage: "calendar")
                        .foregroundColor(.gray)
                    
                    Text("Description")
                        .font(.headline)
                    Text("Welcome to PaddyTrade, your direct gateway to a seamless agricultural trading experience!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 10) {
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
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        NotificationManager.shared.requestAuthorization()
                        NotificationManager.shared.scheduleNotification(
                            title: "Bid Place Sucess!",
                            body: "You have placed bid sucessfully",
                            afterSeconds: 1
                        )
                    }) {
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.splashGreen)
        })
    }
    
}


#Preview {
    BidDetailView(bid: .init(
        imageName: "paddy_image",
        name: "Samba Paddy",
        location: "Thalawa",
        price: 125,
        totalWeight: 1545,
        date: "2025/03/15"
    ))
}

//
//  HomeView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI

struct HomeView: View {
    let cards: [CardData] = [
        CardData(title: "Place A Bid", bigIcon: "rupeesign.square", smallIcon: "plus.circle", backgroundColor: Color.yellow.opacity(0.2)),
        CardData(title: "Bid Analysis", bigIcon: "chart.bar", smallIcon: "doc.text.magnifyingglass", backgroundColor: Color.green.opacity(0.3)),
        CardData(title: "Place A Harvest", bigIcon: "leaf", smallIcon: "plus.circle", backgroundColor: Color.green.opacity(0.4)),
        CardData(title: "Harvest Analysis", bigIcon: "chart.pie", smallIcon: "doc.text.magnifyingglass", backgroundColor: Color.yellow.opacity(0.15))
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("Good Morning")
                                .font(.system(size: 12 , weight: .regular))
                            Text("Sandamal Senayake")
                                .font(.system(size: 22 , weight: .semibold))
                        }
                        Spacer()
                        Image(systemName: "bell.fill")
                            .fontWeight(.medium)
                            .font(.system(size: 25))
                            .padding(.top, 3)
                            .foregroundColor(.splashGreen)
                    }
                }
                .padding()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cards) { card in
                        if card.title == "Place A Bid" {
                            NavigationLink(destination: BidListView()) {
                                CardView(card: card)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if card.title == "Bid Analysis" {
                            NavigationLink(destination: BidAnalyzingView()) {
                                CardView(card: card)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            CardView(card: card)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                NotificationManager.shared.requestAuthorization()
                // For Test
//                NotificationManager.shared.scheduleNotification(
//                    title: "Reminder",
//                    body: "Check your Paddy Trade stats!",
//                    afterSeconds: 10
//                )
//
//                NotificationManager.shared.scheduleNotification(
//                    title: "Reminder 2",
//                    body: "Check your Paddy Trade stats!",
//                    afterSeconds: 20
//                )
//                
//                NotificationManager.shared.scheduleNotification(
//                    title: "Reminder 3",
//                    body: "Check your Paddy Trade stats!",
//                    afterSeconds: 30
//                )
            }
        }
    }
}



struct CardData: Identifiable {
    let id = UUID()
    let title: String
    let bigIcon: String
    let smallIcon: String
    let backgroundColor: Color
}

struct CardView: View {
    let card: CardData
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.backgroundColor)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(card.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: card.bigIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                    Spacer()
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    Spacer()
                    Image(systemName: card.smallIcon)
                        .font(.title3)
                        .foregroundColor(.black)
                        .opacity(0.5)
                }
                .padding(.top, -10)
            }
            .padding()
        }
        .frame(height: 180)
        .padding(.horizontal,2)
    }
}

#Preview {
    HomeView()
}

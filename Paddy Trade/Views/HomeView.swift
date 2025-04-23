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
        NavigationStack {
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
                        NavigationLink(destination: NotificationListView()) {
                            Image(systemName: "bell.fill")
                                .fontWeight(.medium)
                                .font(.system(size: 25))
                                .padding(.top, 3)
                                .foregroundColor(.splashGreen)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                
                HStack {
                   Image("cover")
                        .resizable()
                        .scaledToFill()
                }
                
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
                .padding(.horizontal)

                
                //WeatherCardView()

                
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
                        } else if card.title == "Place A Harvest" {
                            NavigationLink(destination: PlaceHarvestView()) {
                                CardView(card: card)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if card.title == "Harvest Analysis" {
                            NavigationLink(destination: HarvestAnalyzingView()) {
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
            
            }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
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

struct WeatherCardView : View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {

                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            TextField("Search location", text: $viewModel.searchQuery)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .onChange(of: viewModel.searchQuery) { _ in
                                    viewModel.updateSearchResults()
                                }

                            List(viewModel.searchResults, id: \.self) { result in
                                Button(action: {
                                    viewModel.selectLocation(completion: result)
                                }) {
                                    Text(result.title + ", " + result.subtitle)
                                }
                            }
                            .frame(height: viewModel.searchResults.isEmpty ? 0 : 200)
                        }

                        if let weather = viewModel.weather {
                            VStack(spacing: 12) {
                                Text(viewModel.locationName)
                                    .font(.title)
                                    .bold()

                                Text("\(Int(weather.currentWeather.temperature.value))°\(weather.currentWeather.temperature.unit.symbol)")
                                    .font(.system(size: 64, weight: .bold))

                                Text(weather.currentWeather.condition.description)
                                    .font(.headline)

                                HStack {
                                    Text("Wind: \(Int(weather.currentWeather.wind.speed.value)) \(weather.currentWeather.wind.speed.unit.symbol)")
                                    Spacer()
                                    Text("Humidity: \(Int(weather.currentWeather.humidity * 100))%")
                                }
                                .padding(.horizontal)
                                .font(.subheadline)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        } else {
                            ProgressView("Loading weather...")
                                .padding()
                        }

                        Spacer()
                    }
                    .navigationTitle("Weather")
                }
            }


#Preview {
    HomeView()
}

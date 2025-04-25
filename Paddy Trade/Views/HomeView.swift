//
//  HomeView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import CoreLocation
import Combine
import _MapKit_SwiftUI

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
                        HStack(spacing: 20) {
                            NavigationLink(destination: NotificationListView()) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.splashGreen)
                            }

                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 25))
                                    .foregroundColor(.splashGreen)
                            }
                        }

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

                
                WeatherCardView()
                    .padding(.horizontal)

                NavigationLink(destination: FullMapView()) {
                    LocationMapCardView()
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())


                
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
            
            NotificationManager.shared.scheduleNotification(title: "#Harvest123 Bid Accepted", body: "Your Harvest123 bid accepted . Please Call 07612322123 ", afterSeconds: 20)
            NotificationManager.shared.scheduleNotification(title: "#Harvest123 Bid Accepted", body: "Your Harvest123 bid accepted . Please Call 07612322123 ", afterSeconds: 40)
            NotificationManager.shared.scheduleNotification(title: "#Harvest123 Bid Accepted", body: "Your Harvest123 bid accepted . Please Call 07612322123 ", afterSeconds: 60)
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



struct WeatherCardView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let weather = viewModel.weather {
                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        Text(viewModel.locationName)
                            .font(.title2)
                            .bold()
                        Spacer()
                        
                        Text("\(weather.condition) climate")
                            .font(.headline)
                    }
                    
                    Text("\(Int(weather.temperature))°C")
                        .font(.system(size: 48, weight: .bold))
                   
                    
                    HStack {
                        Text("Wind: \(Int(weather.windSpeed)) km/h")
                        Spacer()
                        Text("Humidity: \(weather.humidity)%")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.15))
                .cornerRadius(16)
                .padding(.vertical, 10)
            } else {
                ProgressView("Fetching Weather...")
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}


#Preview {
    HomeView()
}


struct FullMapView: View {
    @StateObject private var viewModel = BidDetailViewModel()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.bids) { bid in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: bid.latitude, longitude: bid.longitude)) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text(bid.name)
                        .font(.caption)
                }
            }
        }
        
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            LocationManager.shared.requestCurrentLocation { location in
                if let location = location {
                    region.center = location.coordinate
                }
            }
            viewModel.fetchAllOtherBids()
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}




struct LocationMapCardView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Bid Areas")
                .font(.headline)
                .padding([.top, .horizontal])

            Map(coordinateRegion: $region)
                .frame(height: 200)
                .cornerRadius(16)
                .onAppear {
                    getCurrentLocation()
                }
        }
        .background(Color.white)
        .cornerRadius(16)
    }

    private func getCurrentLocation() {
        LocationManager.shared.requestCurrentLocation { location in
            if let location = location {
                region.center = location.coordinate
            }
        }
    }
}

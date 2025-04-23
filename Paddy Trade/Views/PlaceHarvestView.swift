//
//  PlaceHarvestView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import SwiftUI
import CoreLocation
import MapKit

struct PlaceHarvestView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var paddyType = "Samba Paddy Yield"
    @State private var totalYield = "1000"
    @State private var basePrice = "120"
    @State private var description = "Welcome to PaddyTrade, your direct gateway to a seamless agricultural trading experience! Designed for simplicity and security."
    @State private var showMap = false
    @State private var selectedLocation: CLLocationCoordinate2D? = nil

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("You can only add a yield between 14 days. That period you can’t add another paddy yield.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type of the Paddy")
                            .fontWeight(.semibold)
                        
                        Menu {
                            Button("Samba Paddy Yield") { paddyType = "Samba Paddy Yield" }
                            Button("Nadu Paddy Yield") { paddyType = "Nadu Paddy Yield" }
                            Button("Red Rice Yield") { paddyType = "Red Rice Yield" }
                        } label: {
                            HStack {
                                Text(paddyType)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .fontWeight(.semibold)
                            .foregroundColor(.splashGreen)
                            .background(Color(.systemGreen).opacity(0.1))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
                        }
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Paddy Yield")
                                .fontWeight(.semibold)
                            TextField("Enter yield", text: $totalYield)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Base Price(Rs)")
                                .fontWeight(.semibold)
                            TextField("Enter price", text: $basePrice)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    
                    HStack {
                        Text("Add an Image")
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                    }
                    
                    HStack {
                        Label(selectedLocation != nil ? "Location Selected" : "Pick Location", systemImage: "location.fill")
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .onTapGesture {
                        showMap = true
                    }
                    .sheet(isPresented: $showMap) {
                        MapPickerView(selectedLocation: $selectedLocation)
                    }

                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .fontWeight(.semibold)
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding()
                            .background(Color(.systemGreen).opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("Place The Harvest")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.splashGreen)
                            .cornerRadius(20)
                            .font(.headline)
                    }
                    .padding(.top)
                    
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.splashGreen)
        })
    }
}

struct InputBox: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}


struct MapPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) var dismiss

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    struct IdentifiableCoordinate: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: selectedLocation.map { [IdentifiableCoordinate(coordinate: $0)] } ?? []
            ) { item in
                MapPin(coordinate: item.coordinate)
            }
            .onTapGesture {
                selectedLocation = region.center
            }
            
            Button {
                dismiss()
            } label: {
                HStack{
                    Spacer()
                    Text("Confirm Location")
                    Spacer()

                }
            }
            .padding(.vertical,10)
            .background(Color.splashGreen)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(20)
        }
    }
}



struct PlaceHarvestView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHarvestView()
    }
}

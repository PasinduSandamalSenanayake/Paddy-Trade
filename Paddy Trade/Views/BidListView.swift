//
//  BidListView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import FirebaseAuth

struct BidListView: View {
    
    @State private var searchString: String = ""
    @State private var showFilterSheet = false
    @State private var filters = FilterData()
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = BidDetailViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Place the bid")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            SearchBar(searchString: $searchString, onFilterTapped: {
                showFilterSheet = true
            })
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredBids) { bid in
                        NavigationLink(destination: BidDetailView(bid: bid)) {
                            BidCardView(bid: bid)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                .foregroundColor(Color.splashGreen)
        })
        .onAppear {
            viewModel.fetchAllOtherBids()
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterView(filters: $filters, allLocations: Array(Set(viewModel.bids.map { $0.location })))
        }
    }
    
    var filteredBids: [Bid] {
        viewModel.bids.filter { bid in
            let matchesSearch = searchString.isEmpty ||
                bid.name.localizedCaseInsensitiveContains(searchString) ||
                bid.location.localizedCaseInsensitiveContains(searchString)
            
            let matchesLocation = filters.selectedLocations.isEmpty || filters.selectedLocations.contains(bid.location)
            
            let matchesPrice = (filters.minPrice == nil || bid.price >= Int(filters.minPrice!)) &&
                               (filters.maxPrice == nil || bid.price <= Int(filters.maxPrice!))
            
            let matchesWeight = filters.minWeight == nil || Double(bid.totalWeight) >= filters.minWeight!
            
            return matchesSearch && matchesLocation && matchesPrice && matchesWeight
        }
    }
}


struct SearchBar: View {
    @Binding var searchString: String
    var onFilterTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onFilterTapped) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
            .padding(.trailing,5)
            
            TextField("Anuradhapura or Samba", text: $searchString)
                .textFieldStyle(PlainTextFieldStyle())
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .opacity(0.5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5)
        .padding()
    }
}

struct BidCardView: View {
    let bid: Bid
    
    var body: some View {
        HStack(alignment: .center) {
            Image(bid.imageName)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                .padding(.trailing,10)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(bid.name)
                        .font(.headline)
                    Spacer()
                    Text("Rs \(bid.price)")
                        .foregroundColor(.splashGreen)
                        .bold()
                    Text("/ per kg")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 4) {
                    Text(bid.location)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Total - \(bid.totalWeight) kg")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                
                HStack{
                    Text(bid.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    VStack{
                        Text("Place a Bid")
                            .fontWeight(.semibold)
                            .font(.system(size: 12))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(Color.splashGreen)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                .padding(.top,5)
            }
            
            Spacer()
            
            
        }
        .padding()
        .background(Color.appWhite)
        .cornerRadius(15)
    }
}

struct FilterView: View {
    @Binding var filters: FilterData
    let allLocations: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Locations")) {
                    ForEach(allLocations, id: \.self) { location in
                        MultipleSelectionRow(title: location, isSelected: filters.selectedLocations.contains(location)) {
                            if filters.selectedLocations.contains(location) {
                                filters.selectedLocations.remove(location)
                            } else {
                                filters.selectedLocations.insert(location)
                            }
                        }
                    }
                }
                
                Section(header: Text("Price (Rs)")) {
                    TextField("Min Price", value: $filters.minPrice, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                    TextField("Max Price", value: $filters.maxPrice, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Minimum Weight (kg)")) {
                    TextField("Min Weight", value: $filters.minWeight, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dismiss()
                    }
                    .foregroundColor(.splashGreen)
                }
            }
        }
        .accentColor(.splashGreen)
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.splashGreen)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.splashGreen)
                }
            }
        }
    }
}


#Preview {
    BidListView()
}

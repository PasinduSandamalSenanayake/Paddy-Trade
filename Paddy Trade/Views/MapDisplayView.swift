//
//  LocationView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import MapKit

struct MapDisplayView: View {
    let bid: Bid
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode


    @State private var region: MKCoordinateRegion

    init(bid: Bid) {
        self.bid = bid
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: bid.latitude, longitude: bid.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: [bid]) { bid in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: bid.latitude, longitude: bid.longitude)) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 15, height: 15)
                }
            }
            .navigationTitle(bid.location)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
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
    }
}

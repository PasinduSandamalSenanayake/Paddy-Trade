//
//  ProfileView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var userEmail: String = ""
    @State private var userName: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            Text(userName)
                .font(.title)
                .fontWeight(.bold)

            Text(userEmail)
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
            
            Button(action: {
                logout()
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .onAppear {
            fetchUserData()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }
        userEmail = user.email ?? ""

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists {
                userName = document.data()?["name"] as? String ?? "No Name"
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

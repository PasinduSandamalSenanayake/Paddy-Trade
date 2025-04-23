//
//  AuthViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import SwiftUI
import Firebase
import FirebaseAuth

// MARK: - ViewModel
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isSignIn = false
    @Published var errorMessage: String?

    init() {
        self.isSignIn = Auth.auth().currentUser != nil
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignIn = true
                }
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isSignIn = true
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignIn = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}


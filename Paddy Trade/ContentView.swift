//
//  ContentView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-15.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var showLogin = false
    @StateObject private var locationManager = LocationManager()


    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        if isAuthenticated {
            HomeView()
        } else if showLogin {
            HomeView()
//            SignInView(loginAction: {_ in
//                
//            })
        } else {
            SplashView()
                .onAppear(perform: authenticateUser)
        }
    }

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access Paddy Trade"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                    } else {
                        showLogin = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                showLogin = true
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        VStack {
            ProgressView("Checking Authentication...")
        }
        .padding()
    }
}


#Preview {
    ContentView()
}

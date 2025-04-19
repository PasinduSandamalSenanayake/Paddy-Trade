//
//  WelcomeView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            

            Text("Welcome to")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.top,20)
                .padding(.bottom,-20)
            HStack(spacing: 0) {
                Text("Paddy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text("Trade")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }

            Spacer()

            Button(action: {
                onGetStarted()
            }) {
                Text("Get Started")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.splashGreen)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
            }

        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView {
        print("Get Started tapped")
    }
}

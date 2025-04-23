//
//  SignInView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateHome: Bool = false
    @State private var navigateRegister: Bool = false
    @State private var errorMessage: IdentifiableString?

    var body: some View {
        NavigationStack {
            ZStack {
                Spacer()

                NavigationLink(destination: RegisterView(), isActive: $navigateRegister) {
                    EmptyView()
                }
                .hidden()

                VStack {
                    Spacer()

                    VStack {
                        HStack(spacing: 0) {
                            Text("Paddy")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.white)
                            Text("Trade")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.lightGreen)
                        }

                        Text("Find Quality Paddy")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.9)
                    }
                    .padding(.top)

                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)

                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)

                        HStack {
                            Spacer()
                            Text("Sign In")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                            Spacer()
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .onTapGesture {
                            signIn()
                        }

                        HStack {
                            Spacer()
                            Text("Don't have an account?")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                                .opacity(0.7)
                            Text("Register")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    navigateRegister = true
                                }
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("SplashGreen"))
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .alert(item: $errorMessage) { message in
            Alert(title: Text("Error"), message: Text(message.value), dismissButton: .default(Text("OK")))
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = IdentifiableString(error.localizedDescription)
            } else {
                navigateHome = true
                email = ""
                password = ""
            }
        }
    }
}

struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String

    init(_ value: String) {
        self.value = value
    }
}

#Preview {
    SignInView()
}

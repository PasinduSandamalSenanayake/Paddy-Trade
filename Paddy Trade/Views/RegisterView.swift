//
//  RegisterView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-16.
//

import SwiftUI

struct RegisterView: View {
    @State private var userId : String = ""
    @State private var password : String = ""
    @State private var navigateSign : Bool =  false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Spacer()
                
                
                    .hidden()
                
                NavigationLink(destination: SignInView(loginAction: {_ in 
                    
                }), isActive: $navigateSign) {
                    EmptyView()
                }
                .hidden()
                
                VStack{
                    Spacer()
                    VStack{
                        HStack(spacing:0){
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
                    VStack{
                        TextField("Username or Email", text: $password)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        TextField("Phone", text: $password)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        
                        SecureField("Password", text: $userId)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        HStack{
                            Spacer()
                            Text("Register Now")
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
                            navigateSign = true
                            userId =  ""
                            password = ""
                        }
                        
                        
                        HStack{
                            Spacer()
                            Text("Do you hace an account?")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                                .opacity(0.7)
                            Text("Sign In")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    navigateSign = true
                                }
                            Spacer()
                        }
                        .padding(.top,10)
                        
                        
                        
                    }
                    .padding(.horizontal,25)
                    .padding(.top)
                    
                    
                    Spacer()
                    
                }
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background(Color("SplashGreen"))
            .ignoresSafeArea()
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    
}




#Preview {
    RegisterView()
}

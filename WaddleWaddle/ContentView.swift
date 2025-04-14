//
//  ContentView.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 07/04/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userData: UserData
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath

    
    var isButtonDisabled: Bool {
        userData.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
                ZStack {
                    Image("BG")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        Text("WADDLE")
                            .font(.custom("ChalkboardSE-Bold", size: 50))
                            .foregroundColor(.black)
                            .padding(.top, 50)
                            .overlay(
                                Text("WADDLE")
                                    .font(.custom("ChalkboardSE-Bold", size: 50))
                                    .foregroundColor(.white)
                                    .padding(.top, 50)
                                    .offset(x: -2, y: -1)
                            )
                        
                        Image("waddlePage1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.top, 50)
                        
                        VStack(spacing: 10) {
                            Text("Hi! What's your name?")
                                .font(.custom("ChalkboardSE-Bold", size: 20))
                                .foregroundColor(.white)
                            
                            TextField("Type here", text: $userData.name)
                                .padding()
                                .frame(width: 325, height: 40)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(30)
                                .multilineTextAlignment(.center)
                                .font(.custom("ChalkboardSE-Regular", size: 15))
                                .foregroundColor(.darkBlue)
                            
                            ZStack {
                                if showAlert {
                                    Text("We'd love to know what to call you!")
                                        .font(.custom("ChalkboardSE-Regular", size: 12))
                                        .foregroundColor(.red)
                                } else {
                                    Text(" ")
                                        .font(.custom("ChalkboardSE-Regular", size: 12))
                                }
                            }
                        }
                        .padding(.top, -50)
                        
                        Button(action: {
                            if isButtonDisabled {
                                showAlert = true
                            } else {
                                showAlert = false
                                print("Navigating to gender page")
                                path = NavigationPath()
                                path.append(Route.gender)
                            }
                        }) {
                            Text("NEXT")
                                .font(.custom("ChalkboardSE-Bold", size: 10))
                                .foregroundColor(.blue2)
                                .padding()
                                .frame(width: 80, height: 25)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                        Spacer()
                    }
                }
        }
}

#Preview {
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        var body: some View {
            ContentView(userData: UserData(), path: $path)
        }
    }
    
    return PreviewWrapper()
}

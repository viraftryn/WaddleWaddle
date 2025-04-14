//
//  WelcomingPage.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 08/04/25.
//

import SwiftUI

enum Route: Hashable {
    case name
    case gender
    case weightHeight
    case activityState
    case intakeFrequency
    case mainPage
    case profilePage
}

struct WelcomePage: View {
    @StateObject private var userData = UserData()
    @State private var path = NavigationPath()
    @State private var fadeOut = false
    @State private var animateLetters: [Bool] = Array(repeating: false, count: 6)
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                BackgroundGradientView()
                
                HStack(spacing: 0) {
                    ForEach(Array("WADDLE".enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.custom("ChalkboardSE-Bold", size: 50))
                            .foregroundColor(.black)
                            .overlay(
                                Text(String(letter))
                                    .font(.custom("ChalkboardSE-Bold", size: 50))
                                    .foregroundColor(.white)
                                    .offset(x: -2, y: -1)
                            )
                            .scaleEffect(animateLetters[index] ? 1.2 : 0.5)
                            .opacity(fadeOut ? 0 : 1)
                            .offset(y: fadeOut ? -30 : 0)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 10).delay(Double(index) * 0.1), value: animateLetters[index])
                            .animation(.easeInOut(duration: 1.0), value: fadeOut)
                    }
                }
                
                .onAppear {
                    // Animate each letter one by one
                    for i in 0..<animateLetters.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                            animateLetters[i] = true
                        }
                    }
//
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                withAnimation {
                                                    fadeOut = true
                                                }

                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                    if userData.isComplete {
                                                        path = NavigationPath()
                                                        path.append(Route.mainPage)
                                                    } else {
                                                        path = NavigationPath()
                                                        path.append(Route.name)
                                                    }
                                                }
                                            }
            
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .name:
                        ContentView(userData: userData, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .gender:
                        Page_2(userData: userData, path: $path)
                    case .weightHeight:
                        Page_3(userData: userData, path: $path)
                    case .activityState:
                        Page_4(userData: userData, path: $path)
                    case .intakeFrequency:
                        Page_5(userData: userData, path: $path)
                    case .mainPage:
                        Page_Main(userData: userData, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .profilePage:
                        Page_Profile(userData: userData, path: $path)
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomePage()
}

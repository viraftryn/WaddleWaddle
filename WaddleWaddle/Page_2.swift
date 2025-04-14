//
//  Page_2.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 07/04/25.
//

import SwiftUI

struct Page_2: View {
    @ObservedObject var userData: UserData
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var isButtonDisabled: Bool {
        userData.gender.isEmpty
    }
    
    var body: some View {
            ZStack{
                BackgroundGradientView()
                GeometryReader { geometry in
                    
                    Circle()
                        .fill(Color.lightGradient) // Use your gradient color
                        .frame(width: geometry.size.width * 1.5, // 3/4 of screen width
                               height: geometry.size.width * 1.5) // Keep it a perfect circle
                        .position(x: geometry.size.width / 2, // Center horizontally
                                  y: geometry.size.height / 1.75) // Adjust as needed
                    
                    Text("Are you a?")
                        .font(.custom("ChalkboardSE-Bold", size: 20))
                        .foregroundColor(.white)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 7.5)
                    
                    if showAlert {
                        Text("Select your gender!")
                            .font(.custom("ChalkboardSE-Regular", size: 12))
                            .foregroundColor(.pinky)
                            .position(x: geometry.size.width / 2,
                                      y: geometry.size.height / 4.7)
                    }
                    
                    Rectangle()
                        .fill(Color.darkBlue)
                        .frame(width: geometry.size.width * 0.7,
                               height: geometry.size.width * 2)
                        .rotationEffect(.degrees(-40))
                        .position(x: geometry.size.width / 3.5,
                                  y: geometry.size.height / 1.07)
                    
                    Rectangle()
                        .fill(Color.blue2)
                        .frame(width: geometry.size.width * 0.7,
                               height: geometry.size.width * 2)
                        .rotationEffect(.degrees(50))
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 0.9)
                }
                VStack(spacing: 20){
                    Spacer()
                        .frame(height: 200)
                    
                    GenderSelectionView(userData: userData)
                    
                        .padding(.top, -50)
                    
                    Text("💡 Gender can affect how much water your body needs to stay properly hydrated. By knowing your gender, we can give you a more accurate hydration goal!")
                        .font(.custom("ChalkboardSE-Regular", size: 12))
                        .foregroundColor(.darkBlue)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 340, height: 90)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(15)
                
                        .padding(.bottom, 25)
                    
                    Button(action: {
                        if isButtonDisabled {
                            showAlert = true
                        } else {
                            showAlert = false
                            print("Navigating to weightHeight page")
                            path = NavigationPath()
                            path.append(Route.weightHeight)
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .weightHeight:
                    Page_3(userData: userData, path: $path)
                default:
                    EmptyView()
                }
            }
        }
}

#Preview {
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        var body: some View {
            Page_2(userData: UserData(), path: $path)
        }
    }
    
    return PreviewWrapper()
}


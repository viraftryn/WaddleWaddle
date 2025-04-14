//
//  Page_5.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 08/04/25.
//

import SwiftUI

struct Page_5: View {
    @ObservedObject var userData: UserData
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    @State private var showPermissionAlert = false
    
    var isButtonDisabled: Bool {
        userData.intakeFrequency < 8
    }
    
    var body: some View {
            ZStack {
                BackgroundGradientView()
                GeometryReader{
                    geometry in
                    
                    Circle()
                        .fill(Color.pastelBlue)
                        .frame(width: geometry.size.width * 0.7,
                               height: geometry.size.width * 2)
                    //.rotationEffect(.degrees(-40))
                        .position(x: geometry.size.width / 3.5,
                                  y: geometry.size.height / 1.13)
                    Circle()
                        .fill(Color.lightBlue)
                        .frame(width: geometry.size.width * 0.7,
                               height: geometry.size.width * 2)
                    //.rotationEffect(.degrees(-40))
                        .position(x: geometry.size.width / 1.3,
                                  y: geometry.size.height / 1.07)
                    
                    Ellipse()
                        .fill(Color.lightGradient)
                        .frame(width: geometry.size.width * 1,
                               height: geometry.size.height * 0.2)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 1)
                }
                
                VStack(spacing: 20) {
                    Spacer()
                    Text("How frequent do you drink \nwater in a day?")
                        .foregroundStyle(.white)
                        .font(.custom("ChalkboardSE-Bold", size: 20))
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Menu {
                            ForEach(Array(8...20).sorted(), id: \.self) { number in
                                Button(action: {
                                    userData.intakeFrequency = number
                                }) {
                                    Text("\(number)")
                                }
                            }
                        } label: {
                            HStack {
                                Text(userData.intakeFrequency >= 8 ? "\(userData.intakeFrequency)" : "Select")
                                    .foregroundColor(.white)
                                    .font(.custom("ChalkboardSE-Bold", size: 16))
                                Text("Times a day")
                                    .foregroundColor(.white)
                                    .font(.custom("ChalkboardSE-Bold", size: 16))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 325, height: 40)
                            .padding()
                            .frame(height: 50)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(30)
                        }
                        
                    }
                    ZStack {
                        if showAlert {
                            Text("Waddle wants to know your daily water intake!")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                                .foregroundColor(.red)
                        } else {
                            Text(" ")
                                .font(.custom("ChalkboardSE-Regular", size: 12))
                        }
                    }
                    
                    Button(action: {
                        if isButtonDisabled {
                            showAlert = true
                        } else {
                            showAlert = false
                            if userData.isComplete {
                                showPermissionAlert = true // Show the alert first
                            }
                        }
                    }) {
                        Text("SUBMIT")
                            .font(.custom("ChalkboardSE-Bold", size: 10))
                            .foregroundColor(.blue2)
                            .padding()
                            .frame(width: 80, height: 25)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    
                    Image("waddlePage5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                    
                }
                .alert(isPresented: $showPermissionAlert) {
                    Alert(
                        title: Text("Enable Notifications"),
                        message: Text("We’ll remind you to drink water throughout the day!\n(8 AM - 9 PM)"),
                        primaryButton: .default(Text("Allow")) {
                            Notification.shared.requestPermission(userData: userData)
//                            Notification.shared.scheduleTestNotification() //TEST NOTIFICATION
                            path = NavigationPath()
                            path.append(Route.mainPage)
                        },
                        secondaryButton: .cancel {
                            path = NavigationPath()
                            path.append(Route.mainPage)
                        }
                    )
                    
                }

            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .mainPage:
                    Page_Main(userData: userData, path: $path)
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
            let userData = UserData()
            userData.intakeFrequency = 0
            return Page_5(userData: userData, path: $path)
        }
    }
    
    return PreviewWrapper()
}

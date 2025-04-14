//
//  Page_4.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 07/04/25.
//

import SwiftUI

struct Page_4: View {
    @ObservedObject var userData: UserData
    @State private var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var activityDescription: String {
        switch userData.activityState {
        case "Low Intensity 🐌":
            return "Little to no exercise. Sitting, studying, or light household chores."
        case "Medium Intensity ⚙️":
            return "You move around regularly. Walking, cycling, or exercising a few times a week."
        case "High Intensity 🏃‍♂️":
            return "You’re very active daily. Intense workouts, manual labor, or high-energy sports."
        default:
            return ""
        }
    }
    
    var isButtonDisabled: Bool {
        userData.activityState.isEmpty
    }
    
    var body: some View {
            ZStack{
                BackgroundGradientView()
                VStack {
                    Spacer()
                    Text("How much do you move daily? \nLet's find the best fit for you! ")
                        .foregroundStyle(.white)
                        .font(.custom("ChalkboardSE-Bold", size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    let options = ["Low Intensity 🐌", "Medium Intensity ⚙️", "High Intensity 🏃‍♂️"]
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                userData.activityState = option
                            }) {
                                Text(option)
                            }
                        }
                    } label: {
                        HStack {
                            Text(userData.activityState.isEmpty ? "Select an option" : userData.activityState)
                                .foregroundColor(.white)
                                .font(.custom("ChalkboardSE-Bold", size: 16))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(width: 325, height: 40)
                        .background(Color(.systemGray4))
                        .cornerRadius(20)
                    }
                    .padding()
                    
                    if !userData.activityState.isEmpty {
                        VStack(spacing: 1){
                            Text(activityDescription)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                        .padding(.bottom, 17)
                    }
                    
                    ZStack {
                        if showAlert {
                            Text("Let Waddle know your daily groove - pick your activity level!")
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
                            path = NavigationPath()
                            path.append(Route.intakeFrequency)
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
                    
                    Image("waddlePage4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .intakeFrequency:
                    Page_5(userData: userData, path: $path)
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
            Page_4(userData: UserData(), path: $path)
        }
    }
    
    return PreviewWrapper()
}

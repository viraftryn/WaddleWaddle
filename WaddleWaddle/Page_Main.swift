//
//  Page_Main.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 08/04/25.
//

import SwiftUI

struct Page_Main: View {
    @ObservedObject var userData: UserData
    @StateObject private var motionManager: MotionManager
    @State private var showInfo = false
    @Binding var path: NavigationPath
    @State private var bobbing = false
    
    init(userData: UserData, path: Binding<NavigationPath>) {
        _motionManager = StateObject(wrappedValue: MotionManager(userData: userData))
        self.userData = userData
        self._path = path
    }
    
    private func progressBar(for sipCount: Int) -> some View {
        let maxSips = motionManager.maxSips
        let fullWidth = UIScreen.main.bounds.width * 0.8
        let progressWidth = CGFloat(sipCount) / CGFloat(maxSips) * fullWidth

        return RoundedRectangle(cornerRadius: 20)
            .fill(
                sipCount < maxSips / 3 ? Color.lightBlue :
                    sipCount < 2 * maxSips / 3 ? Color.blue2 :
                    Color.darkBlue
            )
            .frame(width: progressWidth, height: 30)
            .animation(.easeInOut(duration: 0.4), value: motionManager.sipCount)
    }

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader{
                    geometry in
                    Image("bgMain")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.2)
                        .position(x: geometry.size.width / 2, // Center horizontally
                                  y: geometry.size.height / 2.2) // Adjust as needed
                }
                VStack {
                    
                    VStack(spacing: 10) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.darkBlue)

                        Text("*Shake* your phone to update\nyour sip-o-meter progress!")
                            .foregroundColor(.darkBlue)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                    
                    ZStack {
                        // Body
                        Image("body")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 270, height: 270)
                            .offset(y:50)

                        // Head
                        Image(userData.gender.lowercased() == "boy" ? "headMale" : "headFemale")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .offset(y:50)
                            .rotationEffect(.degrees(bobbing ? -7 : 7))
                            .animation(.easeInOut(duration: 0.8).repeatCount(3, autoreverses: true), value: bobbing)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle()) // Makes the whole ZStack tappable
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            bobbing = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withTransaction(Transaction(animation: .none)) {
                                bobbing = false
                            }
                        }
                    }

                    // Sip-o-meter
                    let totalWaterML = userData.calculateWaterIntakeML()
                    let frequency = Int(userData.intakeFrequency)
                    let mlPerSip = totalWaterML / frequency

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Sip-o-meter")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                showInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                            }
                            .alert("What is Sip-o-meter?", isPresented: $showInfo) {
                                Button("Got it!", role: .cancel) { }
                            } message: {
                                Text("The sip-o-meter tracks your water intake. Shake your phone to log a sip and stay hydrated!")
                            }
                        }

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.4))
                                .frame(height: 30)

                            progressBar(for: motionManager.sipCount)
                        }
                        HStack{
                            Text("Goal: \(totalWaterML) ml \n(\(mlPerSip) ml per sip)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .bold()
                            
                            Text("\(motionManager.sipCount)/\(frequency) Sips")
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }

                    }
                    .padding()
                    .background(Color.darkBlue.opacity(0.9))
                    .cornerRadius(20)
                    .padding()
                }
                .padding()
            }
            
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 205){
                        Text("Hello \(userData.name.isEmpty ? "User" : userData.name)!")
                            .foregroundStyle(Color.darkBlue)
                            .bold()
                        
                        NavigationLink(value: Route.profilePage) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.darkBlue)
                        }
                    }
                }
            }
            .alert(isPresented: $motionManager.showShakeAlert) {
                Alert(
                    title: Text("Shake Already Used"),
                    message: Text(motionManager.shakeAlertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview{
    struct PreviewWrapper: View {
        @State var path = NavigationPath()
        @State var usr: UserData = UserData()
        
        var body: some View {
            Page_Main(userData: UserData(), path: $path)
                .onAppear(){
                    usr.gender = "Boy" //enumeration
                    usr.height = 160
                    usr.weight = 60
                    usr.activityState = "Light"
                    usr.intakeFrequency = 10
                }
        }
    }
    return PreviewWrapper()
}

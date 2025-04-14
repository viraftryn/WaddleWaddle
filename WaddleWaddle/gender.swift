//
//  gender.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 07/04/25.
//

import SwiftUI

struct GenderCard: View {
    var imageName: String
    var gender: String
    @ObservedObject var userData: UserData

    var isSelected: Bool {
        userData.gender == gender
    }
    
    var textColor:Color{
        isSelected ? Color.white : Color.black
    }
    
    var genderColor:Color{
        if isSelected {
            return gender == "Boy" ? Color.genderBoy : Color.genderPink
        }
        else {
            return Color.white
        }
    }
    
    var body: some View {
            Button(action: {
                userData.gender = gender
            }) {
                VStack(spacing:0) {
                    ZStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height:170)
                            .clipped()
                    }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSelected
                            ? AnyShapeStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [genderColor.opacity(0.6), genderColor]),
                                    startPoint: .topLeading,
                                    endPoint: .bottom
                                )
                            )
                            : AnyShapeStyle(Color.white)
                        )


 // Change color if selected
                        .frame(height: 110)
                        .overlay(
                            Text(gender)
                                .foregroundColor(textColor)
                                .bold(isSelected)
                                .font(.system(size: 27))
                        )
                }
                .frame(width: 170)
                .shadow(radius: 5)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? genderColor : Color.lightGrey, lineWidth: 3)
                )
            }
        }
    }

struct GenderSelectionView: View {
    @ObservedObject var userData: UserData

    var body: some View {

        HStack(spacing: 20) {
            GenderCard(imageName: "waddleBoy", gender: "Boy", userData: userData)
            GenderCard(imageName: "waddleGirl", gender: "Girl", userData: userData)
        }
        .padding()
    }
}

#Preview {
    GenderSelectionView(userData: UserData())
}

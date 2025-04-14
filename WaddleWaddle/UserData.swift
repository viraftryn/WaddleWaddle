//
//  UserData.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 07/04/25.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "userName")
        }
    }
    
    @Published var gender: String {
        didSet {
            UserDefaults.standard.set(gender, forKey: "userGender")
        }
    }
    
    @Published var weight: Double {
        didSet {
            UserDefaults.standard.set(weight, forKey: "userWeight")
        }
    }
    
    @Published var height: Double {
        didSet {
            UserDefaults.standard.set(height, forKey: "userHeight")
        }
    }
    
    @Published var activityState: String {
        didSet {
            UserDefaults.standard.set(activityState, forKey: "userActivity")
        }
    }
    
    @Published var intakeFrequency: Int {
        didSet {
            UserDefaults.standard.set(intakeFrequency, forKey: "userFrequency")
        }
    }
    
    var isComplete: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !gender.isEmpty &&
        weight > 0 &&
        height > 0 &&
        !activityState.isEmpty &&
        intakeFrequency >= 8
    }
    
    init() {
        if CommandLine.arguments.contains("-resetUserDefaults") {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }

        self.name = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.gender = UserDefaults.standard.string(forKey: "userGender") ?? ""
        self.weight = UserDefaults.standard.double(forKey: "userWeight")
        self.height = UserDefaults.standard.double(forKey: "userHeight")
        self.activityState = UserDefaults.standard.string(forKey: "userActivity") ?? ""
        self.intakeFrequency = UserDefaults.standard.integer(forKey: "userFrequency")
    }
    
    func calculateWaterIntakeML() -> Int {
        var base: Double
        if gender == "Male" {
            base = weight * 2.205 * 0.67
        } else {
            base = weight * 2.205 * 0.5
        }
        
        switch activityState {
        case "Low Intensity 🐌":
            base += 6
        case "Medium Intensity ⚙️":
            base += 12
        case "High Intensity 🏃‍♂️":
            base += 24
        default:
            break
        }
        
        let ml = (base + 12) * 29.574
        return Int(ml)
    }
}

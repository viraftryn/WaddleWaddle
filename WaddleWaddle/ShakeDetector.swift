//
//  ShakeDetector.swift
//  WaddleWaddle
//
//  Created by Vira Fitriyani on 08/04/25.
//

import SwiftUI
import CoreMotion
import UIKit

class MotionManager: ObservableObject {
    private var motion = CMMotionManager()
    private var timer: Timer?
    private let userData: UserData

    @Published var sipCount: Int = UserDefaults.standard.integer(forKey: "sipCount")
    @Published var showShakeAlert = false
    @Published var shakeAlertMessage = ""

    private var lastShakePeriodIndex: Int = UserDefaults.standard.integer(forKey: "lastShakePeriodIndex")
    private let startHour = 8
    private let endHour = 21

    var maxSips: Int {
            max(userData.intakeFrequency, 1)
        }
    
    private let sipKey = "sipCount"
    private let periodKey = "lastShakePeriodIndex"
    private let dateKey = "lastResetDate"

    init(userData: UserData) {
            self.userData = userData
            checkIfShouldReset()
            startMotionUpdates()
        }
    
    private func checkIfShouldReset() {
        // Reset Daily
//            let calendar = Calendar.current
//            let today = calendar.startOfDay(for: Date())
//            let lastReset = UserDefaults.standard.object(forKey: dateKey) as? Date ?? .distantPast
//            let lastResetDay = calendar.startOfDay(for: lastReset)
//
//            if today > lastResetDay {
//                sipCount = 0
//                lastShakePeriodIndex = -1
//                UserDefaults.standard.set(sipCount, forKey: sipKey)
//                UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
//                UserDefaults.standard.set(Date(), forKey: dateKey)
//            }
        
        // Reset in 2.5 minutes
        let now = Date()
            let lastReset = UserDefaults.standard.object(forKey: dateKey) as? Date ?? .distantPast

            // Reset if more than 2 minutes have passed since last reset
            if now.timeIntervalSince(lastReset) > 150 {
                sipCount = 0
                lastShakePeriodIndex = -1 // reset to an invalid index
                UserDefaults.standard.set(sipCount, forKey: sipKey)
                UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
                UserDefaults.standard.set(now, forKey: dateKey)

                print("Reset occurred! New sipCount: \(sipCount), new lastShakePeriodIndex: \(lastShakePeriodIndex)")
            }
        }

    func startMotionUpdates() {
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 0.2
            motion.startAccelerometerUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in self.checkIfShouldReset()
                
                if let data = self.motion.accelerometerData {
                    let acceleration = data.acceleration
                    let threshold = 2.3
                    let vector = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)

                    if vector > threshold && self.sipCount < self.maxSips {
                        self.handleShakeIfNeeded(frequency: self.maxSips)
                    }
                }
            }
        }
    }

//    func getCurrentPeriodIndex(frequency: Int, startHour: Int = 8, endHour: Int = 21) -> Int? {
//        let calendar = Calendar.current
//        let now = Date()
//        let components = calendar.dateComponents([.hour, .minute], from: now)
//
//        guard let hour = components.hour, let minute = components.minute else { return nil }
//
//        let totalMinutes = (endHour - startHour) * 60
//        let interval = totalMinutes / frequency
//        let currentMinutes = (hour - startHour) * 60 + minute
//
//        guard currentMinutes >= 0 && currentMinutes < totalMinutes else { return nil }
//
//        return currentMinutes / interval
//    }

//    func handleShakeIfNeeded(frequency: Int) {
//        guard let currentPeriod = getCurrentPeriodIndex(frequency: frequency, startHour: startHour, endHour: endHour) else { return }
//
//        if currentPeriod != lastShakePeriodIndex {
//            sipCount += 1
//            lastShakePeriodIndex = currentPeriod
//
//            // Save both to UserDefaults
//            UserDefaults.standard.set(sipCount, forKey: sipKey)
//            UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
//
//            // Haptic feedback
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.prepare()
//            generator.impactOccurred()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                generator.impactOccurred()
//            }
//
//        } else {
//            print("Oh no! shake has already been used for this period (\(currentPeriod))")
//            shakeAlertMessage = "Oops! You’ve already shaken during this period. Please wait for the next notification to shake again."
//            showShakeAlert = true.
//        }
//    }
    
    // Shake Temporary 1-Minute
    func getCurrentPeriodIndex() -> Int {
        let now = Date()
        return Int(now.timeIntervalSince1970 / 60) // one "period" = one minute
    }
    
    func handleShakeIfNeeded(frequency: Int) {
        let currentPeriod = getCurrentPeriodIndex()

        if currentPeriod != lastShakePeriodIndex {
            sipCount += 1
            lastShakePeriodIndex = currentPeriod

            // Save both to UserDefaults
            UserDefaults.standard.set(sipCount, forKey: sipKey)
            UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)

            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                generator.impactOccurred()
            }

        } else {
            print("Oh no! shake has already been used for this period (\(currentPeriod))")
            shakeAlertMessage = "Oops! You’ve already shaken during this period. Please wait for the next notification to shake again."
            showShakeAlert = true
        }
    }


    deinit {
        motion.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}


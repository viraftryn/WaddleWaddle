//
//  Notification.swift
//  WaddleWaddle
//
//  Created by Alifa Reppawali on 09/04/25.
//

import Foundation
import UserNotifications

class Notification{
    static let shared = Notification()
    
    private init() {}
    
//    func scheduleTestNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "🚨 Test Notification"
//        content.body = "This is a test to confirm notifications are working!"
//        content.sound = UNNotificationSound.default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Failed to schedule test notification: \(error.localizedDescription)")
//            } else {
//                print("✅ Test notification scheduled in 1 minute")
//            }
//        }
//    }
    
    // Temporary 1-minute notifications
        func scheduleWaterReminders(for userData: UserData) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
    
            for i in 1...userData.intakeFrequency {
                let content = UNMutableNotificationContent()
                content.title = "💧 Time to Hydrate"
                content.body = "Hey \(userData.name), drink your water and shake your waddle!"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("waddleNotification.wav"))
    
                // Trigger notification every 60 seconds (1 minute apart) for testing
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 60), repeats: false)
    
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    
    func requestPermission(userData: UserData) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Permission granted? \(granted ? "✅ YES" : "❌ NO")")
            }
            
            if granted {
                DispatchQueue.main.async {
                    self.scheduleWaterReminders(for: userData)
                }
            }
        }
        
        //    func scheduleWaterReminders(for userData: UserData) {
        //        let center = UNUserNotificationCenter.current()
        //        center.removeAllPendingNotificationRequests()
        //
        //        let startHour = 8
        //        let endHour = 21
        //        let totalMinutes = (endHour - startHour) * 60
        //        let frequency = max(userData.intakeFrequency, 1)
        //        let interval = totalMinutes / frequency
        //
        //        for i in 0..<frequency {
        //            let minutesFromStart = i * interval
        //            let hour = startHour + (minutesFromStart / 60)
        //            let minute = minutesFromStart % 60
        //
        //            var dateComponents = DateComponents()
        //            dateComponents.hour = hour
        //            dateComponents.minute = minute
        //
        //            let content = UNMutableNotificationContent()
        //            content.title = "💧 Time to Hydrate"
        //            content.body = "Hey \(userData.name), take a sip of water!"
        //            content.sound = UNNotificationSound(named: UNNotificationSoundName("waddleNotification.wav"))
        //
        //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        //
        //            center.add(request)
        //        }
        //    }
    }
}

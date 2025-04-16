//
//  Paddy_TradeApp.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-15.
//
import SwiftUI
import UserNotifications

@main
struct Paddy_TradeApp: App {
    
    init() {
        // Request notification permission when the app starts
        NotificationManager.shared.requestAuthorization()
        UNUserNotificationCenter.current().delegate = NotificationManager.shared as! any UNUserNotificationCenterDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

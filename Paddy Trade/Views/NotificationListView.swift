//
//  NotificationListView.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-23.
//

import Foundation
import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
}

let dummyNotifications: [Notification] = [
    Notification(title: "New Order", message: "You have received a new order for 20kg of paddy.", time: "Just now"),
    Notification(title: "Price Update", message: "Market price increased to Rs 223/kg.", time: "10 mins ago"),
    Notification(title: "Reminder", message: "Don't forget to update your harvest details.", time: "1 hour ago"),
    Notification(title: "Weekly Summary", message: "Your weekly sales report is ready.", time: "Yesterday"),
]

struct NotificationListView: View {
    var notifications: [Notification] = dummyNotifications
    
    var body: some View {
        NavigationView {
            List(notifications) { notification in
                NotificationCard(notification: notification)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 4)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Notifications")
            .padding(.horizontal)
        }
    }
}

struct NotificationCard: View {
    let notification: Notification
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(notification.time)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    NotificationListView()
}

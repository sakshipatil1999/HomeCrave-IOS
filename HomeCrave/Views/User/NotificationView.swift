//
//  NotificationView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct NotificationView: View {
    @State var notifications: [Notification] = [
        Notification(title: "New offer available", message: "Get 20% off on all orders above $50."),
        Notification(title: "Your order is on the way", message: "Your food will be delivered in 10 minutes."),
        Notification(title: "New restaurant added", message: "Try out our latest restaurant with amazing deals."),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notifications")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            if notifications.isEmpty {
                Text("No notifications yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
            } else {
                ForEach(notifications) { notification in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(notification.title)
                            .font(.headline)
                        Text(notification.message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

//
//  NotificationData.swift
//  reef
//
//  Created by Conor Sheehan on 10/7/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  enum NotificationType: String {
    case tankLevelLow, cyclingComplete, seedlingComplete, trimPlant, dryingComplete
    
    func getTitle() -> String {
      switch self {
      case .tankLevelLow:
        return "Tank Level Low"
      case .cyclingComplete:
        return "Cycling Complete!"
      case .seedlingComplete:
        return "Seedling Complete!"
      case .trimPlant:
        return "Trim Plant"
      case .dryingComplete:
        return "Drying Complete!"
      }
    }
      
      func getSubtitle() -> String {
      switch self {
      case .tankLevelLow:
        return "The water level in your aquarium is getting low. Tap to refill"
      case .cyclingComplete:
        return "You can now introduce fish to your aquarium. Tap to learn more"
      case .seedlingComplete:
        return "Your plant is now entering vegetative growth."
      case .trimPlant:
        return "It's now time to trim your plant. Tap to learn how."
      case .dryingComplete:
        return "Drying is complete! Enjoy your reef harvest!"
      }
    }
  }
    
    struct Notifications {
      var currNotifications: [(Date, NotificationType)] = []
      
      func getData() -> [NotificationData] {
        var notificationData: [NotificationData] = []
        for noti in currNotifications {
          let data = NotificationData(title: noti.1.getTitle(), subtitle: noti.1.getSubtitle(), dateAdded: noti.0)
          notificationData.append(data)
        }
        return notificationData
      }
      
      func count() -> Int { return currNotifications.count }
      
    }
  
  func deleteNotification(at index: Int) {
    let notificationDateString = notificationData.currNotifications[index].0.convertToString()
    print("Date string to delete", notificationDateString)
    // Delete notification node from firebase
    notificationsRef?.child(notificationDateString).removeValue()
    // Delete notification locally
    notificationData.currNotifications.remove(at: index)
  }
}

// Firebase reader
extension AppBrain {
  
  func readNotifications() {
    
    notificationsRef?.observe(.value, with: { (snapshot) in
      if let notifications = snapshot.children.allObjects as? [DataSnapshot] {
        self.notificationData.currNotifications = []
        for data in notifications {
          let notiDate = data.key.convertStringToDate()
          if let notificationType = data.value as? String {
            if let notiType = NotificationType(rawValue: notificationType) {
              self.notificationData.currNotifications.insert((notiDate, notiType), at: 0)
            }
          }
        }
      }
    })
  }
  
}

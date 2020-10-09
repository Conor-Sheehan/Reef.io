//
//  FirebaseReader.swift
//  reef
//
//  Created by Conor Sheehan on 8/26/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  func readSensorData(completion: @escaping () -> Void) {
    
     sensorDataRef?.observeSingleEvent(of: .value) { (snapshot) in
         
          if let reefDataTree =  snapshot.children.allObjects as? [DataSnapshot] {
         
           for sensorNode in reefDataTree {
             
             if let sensorValues = sensorNode.children.allObjects as? [DataSnapshot] {
               for sensorData in sensorValues {
                 if let sensorValue = sensorData.value as? Double {
                  let dateAdded = sensorData.key.convertStringToDate()
                  self.storeSensorData(branch: sensorNode.key, dateAdded: dateAdded, sensorValue: sensorValue)
                 }
               }
             }
           }
           completion()
         }
       }
  }
    
  // Takes a user's ReefID and returns if it is a valid reef ID
  func validateReefID(with reefID: String, completion: @escaping (_ isValid: Bool) -> Void) {

    var validIDs: [String] = []

    databaseRef?.child("ReefID").child("ValidIDs").observeSingleEvent(of: .value) { (snapshot) in

      if let children =  snapshot.children.allObjects as? [DataSnapshot] {

        for child in children { validIDs.append(child.key) }
        completion(self.containsValidReefID(reefID: reefID, validIDs: validIDs))
      }
    }
  }
  
  // Reads Grow Tracker data from firebase
  func readGrowTrackerData(completion: @escaping () -> Void) {
    
    readCurrentGrowData(completion: {
      self.growTrackerRef?.observeSingleEvent(of: .value) { (snapshot) in
              
        if let growTrackerTree =  snapshot.children.allObjects as? [DataSnapshot] {
          for data in growTrackerTree {
            if let intData = data.value as? Int {
              self.storeGrowTrackerData(branch: data.key, intData: intData, stringData: "")
            } else if let stringData = data.value as? String {
              self.storeGrowTrackerData(branch: data.key, intData: 0, stringData: stringData)
            }
          }
          completion()
        }
      }
    })
  }
  
  func storeGrowTrackerData(branch: String, intData: Int, stringData: String) {
    switch branch {
    case GrowTrackerBranch.currentGrowStage.rawValue:
      self.growTracker.currentGrowStage = ReefGrowStage(rawValue: stringData) ?? .ecosystemSetup
    case GrowTrackerBranch.completedGrows.rawValue:
      self.growTracker.completedGrows = intData
    case GrowTrackerBranch.growTasksComplete.rawValue:
      self.growTracker.growTasksComplete = intData
    case GrowTrackerBranch.currentSetupStage.rawValue:
      self.growTracker.currentSetupStage = EcosystemSetupStage(rawValue: stringData) ?? .firstSetup
    case GrowTrackerBranch.setupTasksComplete.rawValue:
      self.growTracker.setupTasksComplete = intData
    default:
      return
    }
  }
  
  // Reads all current grow data from Firebase
  func readCurrentGrowData(completion: @escaping () -> Void) {
    
    let currGrowRef = growTrackerRef?.child(GrowTrackerBranch.allGrows.rawValue).child(String(growTracker.completedGrows))
    
    currGrowRef?.observeSingleEvent(of: .value) { (snapshot) in
      if let currGrowTree = snapshot.children.allObjects as? [DataSnapshot] {
         for data in currGrowTree {
           if let growData = data.value as? String {
            self.storeCurrentGrowData(branch: data.key, data: growData)
          }
        }
      }
    }
    
    ecosystemRef?.observeSingleEvent(of: .value) { (snapshot) in
      if let ecosystemTree = snapshot.children.allObjects as? [DataSnapshot] {
        for data in ecosystemTree {
          if let ecosystemData = data.value as? String {
            self.storeEcosystemData(branch: data.key, data: ecosystemData, bool: false)
          } else if let boolData = data.value as? Bool {
            self.storeEcosystemData(branch: data.key, data: "", bool: boolData)
          }
        }
        completion()
      }
    }
  }
  
  // Reads the current water level in the reef grow system during the tank fill process
  func readWaterLevel(completion: @escaping (Int) -> Void) {
    reefScriptsRef?.child(ReefScriptsBranch.waterLevel.rawValue).observe(.value, with: { (snapshot) in
      if let waterLevel = snapshot.value as? Int { completion(waterLevel) }
    })
  }
  
  func observeReefSettings(completion: @escaping () -> Void) {
    
    reefSettingsRef?.observe(.value, with: { (snapshot) in
      if let reefSettingsTree = snapshot.children.allObjects as? [DataSnapshot] {
        for branch in reefSettingsTree {
          self.storeReefSettings(branch: branch.key, data: branch.value)
        }
        completion()
      }
    })
  }
  
  func readNotifications() {
    
    notificationsRef?.observe(.value, with: { (snapshot) in
      if let notifications = snapshot.children.allObjects as? [DataSnapshot] {
        self.notificationData.currNotifications = []
        for data in notifications {
          let notiDate = data.key.convertStringToDate()
          print("Data.key", data.key, "Date notification stored", notiDate)
          if let notificationType = data.value as? String {
            if let notiType = NotificationType(rawValue: notificationType) {
              self.notificationData.currNotifications.insert((notiDate, notiType), at: 0)
            }
          }
        }
      }
    })
  }
  
  func storeReefSettings(branch: String, data: Any?) {
    switch branch {
    case ReefSettingsBranch.lastConnected.rawValue:
      let lastConnectedStr = data as? String
      reefSettings.lastConnected = lastConnectedStr?.convertStringToDate()
    case ReefSettingsBranch.ssid.rawValue:
      reefSettings.ssid = data as? String
    case ReefSettingsBranch.sunrise.rawValue:
      reefSettings.sunrise = data as? String
    case ReefSettingsBranch.growStage.rawValue:
      reefSettings.growStage = data as? Int
    default:
      print("Nothing for now")
    }
  }
  
  func readWiFiStatus(completion: @escaping () -> Void) {

    // Check if user has been authorized by firebase
    let wifiPathRef = reefSettingsRef?.child(ReefSettingsBranch.lastConnected.rawValue)
      // Begin reading path
      wifiPathRef?.observe(.value, with: { (snapshot) in
        if let lastConnected = snapshot.value as? String {
          self.reefSettings.lastConnected = lastConnected.convertStringToDate()
          completion()
        } else { print("WiFi not yet connected") }
    })
  }
  
}

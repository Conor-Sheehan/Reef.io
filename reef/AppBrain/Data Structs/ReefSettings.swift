//
//  ReefSettings.swift
//  reef
//
//  Created by Conor Sheehan on 8/13/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  struct ReefSettings {
    var lastConnected: Date?
    var ssid: String?
    var sunrise: String?
    var growStage: Int?
  }

  func enableTankFilling(isEnabled: Bool) {
    reefSettingsRef?.child("fillingTank").setValue(isEnabled)
  }
  
  func finishReadingWaterLevel() {
    reefSettingsRef?.child("waterLevel").removeAllObservers()
    reefSettingsRef?.child("fillingTank").setValue(false)
  }
  
  func finishConnectingWifi() {
    if let firebaseID = userUID {
      databaseRef?.child("Users").child(firebaseID).child("Reef").child("WiFiLastConnected").removeAllObservers()
    }
  }
}

// Firebase reader
extension AppBrain {
  
  // Setup reef settings observer to read and watch for updates
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
      return
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
  
  // Reads the current water level in the reef grow system during the tank fill process
  func readWaterLevel(completion: @escaping (Int) -> Void) {
    reefScriptsRef?.child(ReefScriptsBranch.waterLevel.rawValue).observe(.value, with: { (snapshot) in
      if let waterLevel = snapshot.value as? Int { completion(waterLevel) }
    })
  }
}

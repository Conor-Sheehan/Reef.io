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

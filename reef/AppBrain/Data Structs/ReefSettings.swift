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
  
  func readWaterLevel(completion: @escaping (Int) -> Void) {
    reefSettingsRef?.child("waterLevel").observe(.value, with: { (snapshot) in
      if let waterLevel = snapshot.value as? Int {
        completion(waterLevel)
      }
    })
  }
  
  func finishReadingWaterLevel() {
    reefSettingsRef?.child("waterLevel").removeAllObservers()
    reefSettingsRef?.child("fillingTank").setValue(false)
  }
  
}

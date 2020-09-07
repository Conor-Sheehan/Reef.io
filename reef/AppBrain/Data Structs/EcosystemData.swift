//
//  EcosystemData.swift
//  reef
//
//  Created by Conor Sheehan on 8/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
  
  struct EcosystemData {
    var ecosystemSetup: Date?
    var cyclingComplete: Bool = false
    var addedFish: Date?
  }
  
  func storeEcosystemData(branch: String, data: String, bool: Bool) {
  
    switch branch {
    case EcosystemBranch.setup.rawValue:
      ecosystemData.ecosystemSetup = data.convertStringToDate()
    case EcosystemBranch.addedFish.rawValue:
      ecosystemData.addedFish = data.convertStringToDate()
    case EcosystemBranch.cyclingComplete.rawValue:
      ecosystemData.cyclingComplete = bool
      print("Cycling complete:", bool)
    default:
      print("Other data:", branch, data)
    }
  }
  
  func isCyclingComplete() -> Bool {
    if growTracker.completedGrows == 0 && ecosystemData.cyclingComplete { return true
    } else { return false }
  }
  
}

//
//  EcosystemData.swift
//  reef
//
//  Created by Conor Sheehan on 8/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  struct EcosystemData {
    var ecosystemSetup: Date?
    var cyclingComplete: Bool = false
    var addedFish: Date?
  }
  
  func observeEcosystemTree(completion: @escaping () -> Void) {
    
    ecosystemRef?.observe(.value, with: { (snapshot) in
      if let ecosystemTree = snapshot.children.allObjects as? [DataSnapshot] {
        for data in ecosystemTree {
          self.storeEcosystemData(branch: data.key, data: data.value)
        }
        print("Ecosystem data read and stored:", self.ecosystemData)
        completion()
      }
    })
  }
  
  func storeEcosystemData(branch: String, data: Any?) {
    
    var date = ""
    var bool = false
    
    // Unwrap the optional data packet to a date or string before storing in struct
    if let dateStr = data as? String { date = dateStr
    } else if let boolean = data as? Bool { bool = boolean
    } else { print("storeEcosystemData function received invalid data packet"); return }
  
    // Store data in proper branch
    switch branch {
    case EcosystemBranch.setup.rawValue:
      ecosystemData.ecosystemSetup = date.convertStringToDate()
    case EcosystemBranch.addedFish.rawValue:
      ecosystemData.addedFish = date.convertStringToDate()
    case EcosystemBranch.cyclingComplete.rawValue:
      ecosystemData.cyclingComplete = bool
    default:
      print("ERROR READING ECOSYSTEM TREE Other data:", branch)
    }
  }
  
  func isCyclingComplete() -> Bool {
    if growTracker.completedGrows == 0 && ecosystemData.cyclingComplete { return true
    } else { return false }
  }
  
}

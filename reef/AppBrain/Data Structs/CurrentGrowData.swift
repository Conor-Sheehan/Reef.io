//
//  StrainData.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

enum SeedType: String { case regular, feminized, autoFlower }

extension AppBrain {
  
  struct CurrentGrowData {
    
    var strainName = String()
    var strainType = String()
    var seedType: SeedType = .regular
    
    var ecosystemSetup: Date?
    var germinated: Date?
    var seedling: Date?
    var vegetative: Date?
    var flowering: Date?
    var drying: Date?
  }
  
  func selectStrain(name: String) {
    currentGrowData.strainName = name
    currentGrowData.strainType = strainDict[name] ?? ""
    
    let currGrowRef = growTrackerRef?.child("AllGrows").child(String(growTracker.completedGrows))
    currGrowRef?.child(AllGrowsBranch.strainName.rawValue).setValue(currentGrowData.strainName)
    currGrowRef?.child(AllGrowsBranch.strainType.rawValue).setValue(currentGrowData.strainType)
  }
  
  func selectSeedType(type: SeedType) {
    currentGrowData.seedType = type
    let currGrowRef = growTrackerRef?.child("AllGrows").child(String(growTracker.completedGrows))
    currGrowRef?.child(AllGrowsBranch.seedType.rawValue).setValue(type.rawValue)
  }
  
  func germinateSeed() {
    let firebaseDate = Date().convertToString()
    let currGrowRef = growTrackerRef?.child("AllGrows").child(String(growTracker.completedGrows))
    currGrowRef?.child(AllGrowsBranch.germinated.rawValue).setValue(firebaseDate)
  }
  
  func storeCurrentGrowData(branch: String, data: String) {
    
    switch branch {
    case AllGrowsBranch.seedType.rawValue:
      currentGrowData.seedType = SeedType(rawValue: data) ?? .regular
    case AllGrowsBranch.strainName.rawValue:
      currentGrowData.strainName = data
    case AllGrowsBranch.strainType.rawValue:
      currentGrowData.strainType = data
    case AllGrowsBranch.seedling.rawValue:
      currentGrowData.seedling = data.convertStringToDate()
    case AllGrowsBranch.germinated.rawValue:
      currentGrowData.germinated = data.convertStringToDate()
    default:
      print("Not storing this data yet:", branch)
    }
  }

}

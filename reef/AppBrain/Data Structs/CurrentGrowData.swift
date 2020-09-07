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
    
    var germinated: Date?
    var seedling: Date?
    var vegetative: Date?
    var flowering: Date?
    var harvest: Date?
    var growComplete: Date?
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
    case AllGrowsBranch.vegetative.rawValue:
      currentGrowData.vegetative = data.convertStringToDate()
    default:
      print("Not storing this data yet:", branch)
    }
  }
  
  // Returns the date that each grow stage started and completed
  func getDateData(stage: ReefGrowStage) -> (dateStarted: Date?, dateComplete: Date?) {
    var dateComplete: Date?
    var dateStarted: Date?
    
    // Get date that each stage started/completed
    switch stage {
    case .germinate:
      dateComplete = currentGrowData.seedling
      dateStarted = currentGrowData.germinated
    case .seedling:
      dateComplete = currentGrowData.vegetative
      dateStarted = currentGrowData.seedling
    case .vegetative:
      dateComplete = currentGrowData.flowering
      dateStarted = currentGrowData.vegetative
    case .flowering:
      dateComplete = currentGrowData.harvest
      dateStarted = currentGrowData.flowering
    case .harvest:
      dateComplete = currentGrowData.growComplete
      dateStarted = currentGrowData.harvest
    default:
      return (nil, nil)
    }
    
    return(dateStarted, dateComplete)
  }

}

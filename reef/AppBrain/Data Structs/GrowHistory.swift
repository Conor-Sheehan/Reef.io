//
//  StrainData.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

enum SeedType: String { case clone, regular, feminized, autoFlower }

extension AppBrain {
  
  struct CurrentGrowData {
    
    // Genetics and seed/clone starting method
    var strainName: String?
    var strainType: String?
    var seedType: SeedType?
    
    // Dates delimiting the first day of each grow stage
    var germinated: Date?
    var seedling: Date?
    var vegetative: Date?
    var flowering: Date?
    var harvest: Date?
    var growComplete: Date?
    
    mutating func reset() {
      self = CurrentGrowData()
    }
  }
  
  struct GrowHistory {
    
    // Genetics and seed/clone starting method
    var strainName: [String]?
    var strainType: [String]?
    var seedType: [SeedType]?
    
    // Dates delimiting the first day of each grow stage
    var germinated: [Date]?
    var seedling: [Date]?
    var vegetative: [Date]?
    var flowering: [Date]?
    var harvest: [Date]?
    var growComplete: [Date]?
    
    mutating func addStrainName(name: String) {
      if (strainName?.append(name)) == nil { strainName = [name] }
    }
    
    mutating func addStrainType(type: String) {
      if (strainType?.append(type)) == nil { strainType = [type] }
    }
    
    mutating func addSeedType(type: SeedType) {
      if (seedType?.append(type)) == nil { seedType = [type] }
    }
    
    mutating func addGerminatedDate(date: Date) {
      if (germinated?.append(date)) == nil { germinated = [date] }
    }
    
    mutating func addSeedlingDate(date: Date) {
      if (seedling?.append(date)) == nil { seedling = [date] }
    }
    
    mutating func addVegetativeDate(date: Date) {
      if (vegetative?.append(date)) == nil { vegetative = [date] }
    }
    
    mutating func reset() {
      self = GrowHistory()
    }
    
  }
  
  // Setter for local and firebase strain storage
  func selectStrain(name: String) {
    let currGrowRef = growHistoryRef?.child(String(growTracker.completedGrows))
    currGrowRef?.child(GrowHistoryBranch.strainName.rawValue).setValue(growHistory.strainName)
    currGrowRef?.child(GrowHistoryBranch.strainType.rawValue).setValue(growHistory.strainType)
  }
  
  // Setter for local and firebase seed type storage
  func selectSeedType(type: SeedType) {
    let currGrowRef = growHistoryRef?.child(String(growTracker.completedGrows))
    currGrowRef?.child(GrowHistoryBranch.seedType.rawValue).setValue(type.rawValue)
  }
  
  // Function to store in firebase the date user germinates their seed
  func germinateSeed() {
    let firebaseDate = Date().convertToString()
    let currGrowRef = growHistoryRef?.child(String(growTracker.completedGrows))
    currGrowRef?.child(GrowHistoryBranch.germinated.rawValue).setValue(firebaseDate)
  }
  
  func completeGermination() {
    
    // Set current grow stage to Seedling
    growTracker.currentGrowStage = .seedling
    growTrackerRef?.child(GrowTrackerBranch.currentGrowStage.rawValue).setValue(growTracker.currentGrowStage.rawValue)
    
    // Reset the number of tasks completed in the current stage
    completeTask(tasksComplete: 0, setupTask: false)
    
    // Set current seedling start date to today
    let currGrowsRef = growHistoryRef?.child(String(growTracker.completedGrows))
    currGrowsRef?.child(GrowHistoryBranch.seedling.rawValue).setValue(Date().convertToString())
    growTrackerRef?.child(GrowTrackerBranch.currentGrowStage.rawValue).setValue(growTracker.currentGrowStage.rawValue)
  }

  // Returns the date that each grow stage started and completed
  func getCurrentGrowDates(stage: ReefGrowStage) -> (stageStarted: Date?, stageComplete: Date?) {
    
    var stageStarted: Date?
    var stageComplete: Date?
    
    // Get date that each stage started/completed
    switch stage {
    case .germinate:
      stageStarted = currentGrowData.germinated
      stageComplete = currentGrowData.seedling
    case .seedling:
      stageStarted = currentGrowData.seedling
      stageComplete = currentGrowData.vegetative
    case .vegetative:
      stageStarted = currentGrowData.vegetative
      stageComplete = currentGrowData.flowering
    case .flowering:
      stageStarted = currentGrowData.flowering
      stageComplete = currentGrowData.harvest
    case .harvest:
      stageStarted = currentGrowData.harvest
      stageComplete = currentGrowData.growComplete
    default:
      return (nil, nil)
    }
    
    return (stageStarted, stageComplete)
  }

}

// Firebase Reader
extension AppBrain {
  
  // Reads all current grow data from Firebase
  func observeGrowHistoryTree(completion: @escaping () -> Void) {
    
    growHistoryRef?.observe(.value, with: { (snapshot) in
      if let growHistory = snapshot.children.allObjects as? [DataSnapshot] {
        
        // Reset all data in arrays to refresh
        self.growHistory.reset()
        
        // Iterate over each grow number (0 ... number of completed grows) in grow history
         for growNumber in growHistory {
          
          // Reset current grow struct for incoming data
          self.currentGrowData.reset()
          
          if let growDataNodes = growNumber.children.allObjects as? [DataSnapshot] {
            
            // Iterate over the grow data for the given grow
            for growData in growDataNodes {
              if let value = growData.value as? String {
               self.storeGrowHistory(branch: growData.key, data: value)
             }
            }
          }
        }
        completion()
      }
    })
  }
  
  func storeGrowHistory(branch: String, data: Any?) {
    
    // Check if data is a valid string value before storing
    if let value = data as? String {
    
      switch branch {
      case GrowHistoryBranch.seedType.rawValue:
        let seedType = SeedType(rawValue: value) ?? .regular
        growHistory.addSeedType(type: seedType)
        currentGrowData.seedType = seedType
      case GrowHistoryBranch.strainName.rawValue:
        growHistory.addStrainName(name: value)
        currentGrowData.strainName = value
      case GrowHistoryBranch.strainType.rawValue:
        growHistory.addStrainType(type: value)
        currentGrowData.strainType = value
      case GrowHistoryBranch.germinated.rawValue:
        let date = value.convertStringToDate()
        growHistory.addGerminatedDate(date: date)
        currentGrowData.germinated = date
      case GrowHistoryBranch.seedling.rawValue:
        let date = value.convertStringToDate()
        growHistory.addSeedlingDate(date: date)
        currentGrowData.seedling = date
      case GrowHistoryBranch.vegetative.rawValue:
        let date = value.convertStringToDate()
        growHistory.addVegetativeDate(date: date)
        currentGrowData.vegetative = date
      default:
        print("Not storing this data yet:", branch)
      }
    }
  }
}

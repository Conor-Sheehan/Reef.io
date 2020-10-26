//
//  GrowProgress.swift
//  reef
//
//  Created by Conor Sheehan on 8/6/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  enum EcosystemSetupStage: String, CaseIterable { case firstSetup, cycling, introduceFish, newSetup
    
    func numberOfTasks() -> Int {
      switch self {
      case .firstSetup:
        return 3
      case .cycling:
        return 0
      case .introduceFish:
        return 1
      case .newSetup:
        return 2
      }
    }
  }
  
  // Defines all steps in the reef Grow Proces and their associated (startDates)
  enum ReefGrowStage: String, CaseIterable {
    case ecosystemSetup, germinate, seedling, vegetative, flowering, harvest
    
    func index() -> Int {
      switch self {
      case .ecosystemSetup:
        return 0
      case .germinate:
        return 1
      case .seedling:
        return 2
      case  .vegetative:
        return 3
      case .flowering:
        return 4
      case .harvest:
        return 5
      }
    }

    func numberOfTasks() -> Int {
      switch self {
      case .germinate:
        return 3
      case .harvest:
        return 1
      default:
        return 0
      }
    }
    
    func daysInStage() -> Int {
      switch self {
      case .seedling:
        return 14
      case  .vegetative:
        return 42
      case .flowering:
        return 60
      case .harvest:
        return 14
      default:
        return 0
      }
    }
  }
  
  struct GrowTracker {
    
    var currentGrowStage: ReefGrowStage
    var growTasksComplete: Int
    var currentSetupStage: EcosystemSetupStage
    var setupTasksComplete: Int
    var completedGrows: Int
    
    // Initialize starting values
    init() {
      currentGrowStage = .ecosystemSetup
      currentSetupStage = .firstSetup
      growTasksComplete = 0
      setupTasksComplete = 0
      completedGrows = 0
    }
    
    // Returns number of steps for the current grow
    func getNumberGrowStages() -> Int { return ReefGrowStage.allCases.count }
    func getNumberSetupStages() -> Int { return EcosystemSetupStage.allCases.count }
    
    func getCurrentStageIndex() -> Int { return currentGrowStage.index() }
    
    func isFirstGrow() -> Bool {
      if completedGrows == 0 { return true
      } else { return false }
    }
  }
  
  /// Retrieves the data associated with the users progress in their current grow cycle
  /// - Returns: Array of GrowStepData for easy access/display on dashboard
  func getGrowTrackerData() -> [ProgressData] {
    
    var progressData = [ProgressData]()
    
    for (index, stage) in ReefGrowStage.allCases.enumerated() {
      
      switch stage {
      case .ecosystemSetup:
        progressData.append(ecosystemSetupData())
      default:
        progressData.append(reefGrowData(index: index, stage: stage))
      }
    }
    return progressData
  }
  
  // CALCULATE AND RETURN ALL GROW TRACKER DATA
    
  func ecosystemSetupData() -> ProgressData {
    
    let currentStage = growTracker.currentSetupStage
    let tasksInStage = currentStage.numberOfTasks()
    let tasksComplete = growTracker.setupTasksComplete
    var status: StageStatus = .inProgress
    var daysLeft: Int = 0
    var percentComplete: Float = Float(tasksComplete)/Float(tasksInStage)
    var dateComplete: Date?
    
    // Handle first grow case
    if growTracker.isFirstGrow() {
      
      switch currentStage {
      case .introduceFish:
        if tasksComplete == 1 { status = .completed }
        dateComplete = ecosystemData.addedFish
      case .cycling:
        daysLeft = 14 - (ecosystemData.ecosystemSetup?.daysElapsed() ?? 0)
        percentComplete = Float(ecosystemData.ecosystemSetup?.daysElapsed() ?? 0)/Float(14)
      default:
        print("Ecosystem setup in progress")
      }
    }
    
    return ProgressData(index: 0, tasksComplete: tasksComplete, numberOfTasks: tasksInStage,
                        status: status, daysLeft: daysLeft, percentComplete: percentComplete,
                        setupStage: currentStage, dateComplete: dateComplete)
  }
  
  func reefGrowData(index: Int, stage: ReefGrowStage) -> ProgressData {
    
    let stageStatus = getStageStatus(stage: stage)
    let tasksInStage = stage.numberOfTasks()
    var tasksComplete = 0
    let (dateStarted, dateComplete) = getDateData(stage: stage)
    var (daysLeft, percentComplete) = getDaysLeftInStage(dateStarted: dateStarted, stage: stage)

    switch stageStatus {
    case .future:
      tasksComplete = 0
    case .completed:
      tasksComplete = tasksInStage
    case .inProgress:
      tasksComplete = growTracker.growTasksComplete
    }
    
    if tasksInStage != 0 { percentComplete = Float(tasksComplete)/Float(tasksInStage) }
    
    return ProgressData(index: index, tasksComplete: tasksComplete, numberOfTasks: tasksInStage,
                        status: stageStatus, daysLeft: daysLeft, percentComplete: percentComplete,
                        setupStage: growTracker.currentSetupStage, dateComplete: dateComplete)
  }
  
  // Returns whether the current stage is complete, in progress, or in the future
  func getStageStatus(stage: ReefGrowStage) -> StageStatus {
    let currentGrowStage = growTracker.currentGrowStage
    
    if stage.index() < currentGrowStage.index() { return .completed
    } else if stage.index() == currentGrowStage.index() { return .inProgress
    } else { return .future }
  }
  
  func getDaysLeftInStage(dateStarted: Date?, stage: ReefGrowStage) -> (daysLeft: Int, percentComplete: Float) {
    let daysSinceStarted = dateStarted?.daysElapsed() ?? 0
    let totalDays =  stage.daysInStage()
    
    // Calculate days left in current grow stage
    var daysLeft = totalDays - daysSinceStarted
    daysLeft = daysLeft > 0 ? daysLeft : 0
    
    // Calculate percent of stage completed
    var percentComplete = Float(daysSinceStarted) / Float(totalDays)
    percentComplete = percentComplete < 1.0 ? percentComplete : 1.0
    
    return (daysLeft, percentComplete)
  }
  
  // HANDLE TASK AND GROW STAGE COMPLETIONS

  func completeTask(tasksComplete: Int, setupTask: Bool) {
    if setupTask {
      if growTracker.currentSetupStage == .introduceFish {
        ecosystemRef?.child(EcosystemBranch.addedFish.rawValue).setValue(Date().convertToString())
      }
      growTracker.setupTasksComplete = tasksComplete
      growTrackerRef?.child(GrowTrackerBranch.setupTasksComplete.rawValue).setValue(growTracker.setupTasksComplete)
    } else {
      growTracker.growTasksComplete = tasksComplete
      growTrackerRef?.child(GrowTrackerBranch.growTasksComplete.rawValue).setValue(growTracker.growTasksComplete)
    }
  }
  
  func completeFirstSetup() {
    completeTask(tasksComplete: 0, setupTask: true)
    growTracker.currentSetupStage = .cycling
    growTracker.currentGrowStage = .germinate
    growTrackerRef?.child(GrowTrackerBranch.currentSetupStage.rawValue).setValue(growTracker.currentSetupStage.rawValue)
    growTrackerRef?.child(GrowTrackerBranch.currentGrowStage.rawValue).setValue(growTracker.currentGrowStage.rawValue)
    ecosystemRef?.child(EcosystemBranch.setup.rawValue).setValue(Date().convertToString())
  }
  
  func completeGermination() {
    completeTask(tasksComplete: 0, setupTask: false)
    growTracker.currentGrowStage = .seedling
    growTrackerRef?.child(GrowTrackerBranch.currentGrowStage.rawValue).setValue(growTracker.currentGrowStage.rawValue)
    let currGrowsRef = allGrowsRef?.child(String(growTracker.completedGrows))
    currGrowsRef?.child(AllGrowsBranch.seedling.rawValue).setValue(Date().convertToString())
    growTrackerRef?.child(GrowTrackerBranch.currentGrowStage.rawValue).setValue(growTracker.currentGrowStage.rawValue)
  }
//
//  func completeGrow(allGrowsRef: DatabaseReference?) {
//    allGrowsRef?.child(AllGrowsBranch.complete.rawValue).setValue(true)
//    growTracker.completedGrows += 1
//    growTrackerRef?.child(GrowTrackerBranch.completedGrows.rawValue).setValue(growTracker.completedGrows)
//    growTracker.currentStage = 0
//  }
    
}

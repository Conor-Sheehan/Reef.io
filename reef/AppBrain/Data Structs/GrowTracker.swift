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
  
//  enum GrowStages: String {
//    case Germination, Seedling, Vegetative, Flowering, Harvest, Drying
//  }
  
  // Defines all steps in the reef Grow Proces and their associated (startDates)
  enum GrowStep {
    case firstSetup, germinate, cycle(Date?), addFish, seedling(Date?),
    vegetative(Date?), flowering(Date?), harvest, drying(Date?), prepareNew
    
    func getDate() -> Date? {
      switch self {
      case .cycle(let date):
        return date
      case .seedling(let date):
        return date
      case .vegetative(let date):
        return date
      case .flowering(let date):
        return date
      case .drying(let date):
        return date
      default:
        return nil
      }
    }
    
    func name() -> String {
      switch self {
      case .firstSetup:
        return "Setup reef"
      case .germinate:
        return "Germinate seed"
      case .cycle:
        return "Cycle tank"
      case .addFish:
        return "Add fish"
      case .seedling:
        return "Seedling"
      case  .vegetative:
        return "Vegetative"
      case .flowering:
        return "Flowering"
      case .harvest:
        return "Harvest"
      case .drying:
        return "Drying"
      case .prepareNew:
        return "Prepare new grow"
      }
    }

    func numberOfTasks() -> Int {
      switch self {
      case .firstSetup:
        return 2
      case .germinate:
        return 3
      case .cycle:
        return 0
      case .addFish:
        return 1
      case .seedling:
        return 0
      case .vegetative:
        return 0
      case .flowering:
        return 0
      case .harvest:
        return 1
      case .drying:
        return 0
      case .prepareNew:
        return 3
      }
    }
  }
  
  struct GrowTracker {
    
    var currentStep: Int
    var tasksComplete: Int
    var completedGrows: Int
    
    // Steps involved for first time reef grower
    var firstGrowSteps: [GrowStep]
    
    // Steps involved for all grows after the first
    var secondaryGrowSteps: [GrowStep]
    
    // Initialize starting values
    init() {
      currentStep = 0
      tasksComplete = 0
      completedGrows = 0
      firstGrowSteps = [.firstSetup, .germinate, .cycle(nil), .addFish, .seedling(nil),
                        .vegetative(nil), .flowering(nil), .harvest, .drying(nil) ]
      secondaryGrowSteps = [.prepareNew, .germinate, .seedling(nil), .vegetative(nil),
                            .flowering(nil), .harvest, .drying(nil)]
    }
    
    // Returns number of steps for the current grow
    func getNumberSteps() -> Int {
      if isFirstGrow() { return firstGrowSteps.count
      } else { return secondaryGrowSteps.count }
    }
    
    func getStepNames() -> [String] {
      var stepNames: [String] =  []
      if isFirstGrow() { for step in firstGrowSteps {  stepNames.append(step.name()) }
      } else { for step in secondaryGrowSteps { stepNames.append(step.name()) }}
      return stepNames
    }
    
    func getCurrentStep() -> GrowStep {
      if isFirstGrow() { return firstGrowSteps[currentStep]
      } else { return secondaryGrowSteps[currentStep] }
    }
    
    func isFirstGrow() -> Bool {
      if completedGrows == 0 { return true
      } else { return false }
    }
    
  }
  
  /// Retrieves the data associated with the users progress in their current grow cycle
  /// - Returns: Array of GrowStepData for easy access/display on dashboard
  func getGrowTrackerData() -> [GrowStepData] {
    
    var growSteps: [GrowStepData] = []
    let tasksComplete = growTracker.tasksComplete
    var growStepArr: [GrowStep] = []
    
    if growTracker.isFirstGrow() { growStepArr = growTracker.firstGrowSteps
    } else { growStepArr = growTracker.secondaryGrowSteps }
    
    // Iterate over grow step arrary and return the current associated data to display the user's progress
    for (index, step) in growStepArr.enumerated() {
      
      let hasTasks = step.numberOfTasks() != 0 ? true : false
      let stepStatus = getStepStatus(index: index)
      
      growSteps.append(GrowStepData(stepName: step.name(), tasksComplete: tasksComplete,
                                  numberOfTasks: step.numberOfTasks(), hasTasks: hasTasks, stepStatus: stepStatus))
    }
    
    return growSteps
  }
  
  // Returns whether the current Grow Step is Completed, In Progress, Or in the Future
  func getStepStatus(index: Int) -> StepStatus {
    var taskStatus: StepStatus
    let currentStep = growTracker.currentStep
    if index < currentStep { taskStatus = StepStatus.completed
    } else if index == currentStep { taskStatus = StepStatus.inProgress
    } else { taskStatus = StepStatus.future }
    return taskStatus
  }
  
  func readGrowTrackerData(completion: @escaping () -> Void) {
    growTrackerRef?.observeSingleEvent(of: .value) { (snapshot) in
            
      if let growTrackerTree =  snapshot.children.allObjects as? [DataSnapshot] {
        for data in growTrackerTree {
          if let trackerData = data.value as? Int {
            self.storeGrowTrackerData(branch: data.key, trackerData: trackerData)
          }
        }
        completion()
      }
    }
  }
  
  func storeGrowTrackerData(branch: String, trackerData: Int) {
    switch branch {
    case GrowTrackerBranch.currentStep.rawValue:
      self.growTracker.currentStep = trackerData
    case GrowTrackerBranch.completedGrows.rawValue:
      self.growTracker.completedGrows = trackerData
    case GrowTrackerBranch.tasksComplete.rawValue:
      self.growTracker.tasksComplete = trackerData
    case GrowTrackerBranch.completedGrows.rawValue:
      self.growTracker.completedGrows = trackerData
    default:
      return
    }
  }
  
  func completeGrowStep() {
    
    let currentGrowStep = growTracker.getCurrentStep()
    let completeGrowsStr = String(growTracker.completedGrows)
    let allGrowsRef = growTrackerRef?.child(GrowTrackerBranch.allGrows.rawValue).child(completeGrowsStr)
    let firebaseDate = Date().convertToString()
    
    growTracker.currentStep += 1
    
    switch currentGrowStep {
    case .firstSetup:
      ecosystemRef?.child(EcosystemBranch.setup.rawValue).setValue(firebaseDate)
    case .germinate:
      allGrowsRef?.child(AllGrowsBranch.germinated.rawValue).setValue(firebaseDate)
    case .cycle:
      print("Nothing for now")
    case .addFish:
      ecosystemRef?.child(EcosystemBranch.addedFish.rawValue).setValue(firebaseDate)
    case .seedling:
      allGrowsRef?.child(AllGrowsBranch.vegetative.rawValue).setValue(firebaseDate)
    case  .vegetative:
      allGrowsRef?.child(AllGrowsBranch.flowering.rawValue).setValue(firebaseDate)
    case .flowering:
       allGrowsRef?.child(AllGrowsBranch.harvest.rawValue).setValue(firebaseDate)
    case .harvest:
       allGrowsRef?.child(AllGrowsBranch.drying.rawValue).setValue(firebaseDate)
    case .drying:
      allGrowsRef?.child(AllGrowsBranch.complete.rawValue).setValue(true)
      growTracker.completedGrows += 1
      growTrackerRef?.child(GrowTrackerBranch.completedGrows.rawValue).setValue(growTracker.completedGrows)
      growTracker.currentStep = 0
    case .prepareNew:
      print("Nothing for now")
    }
    
    // Increment current grow step and store in Firebse
    growTrackerRef?.child(GrowTrackerBranch.currentStep.rawValue).setValue(growTracker.currentStep)
  }
    
}

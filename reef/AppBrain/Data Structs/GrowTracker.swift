//
//  GrowProgress.swift
//  reef
//
//  Created by Conor Sheehan on 8/6/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
  
  enum GrowStages: String {
    case Germination, Seedling, Vegetative, Flowering, Harvest, Drying
  }
  
  // Defines all steps in the reef Grow Proces and their associated (startDates)
  enum GrowStep {
    case FirstSetup(Date?), Germinate(Date?), Cycle(Date?), AddFish(Date?), Seedling(Date?),
    Vegetative(Date?), Flowering(Date?), Harvest(Date?), Drying(Date?), PrepareNew(Date?)
    
    func name() -> String {
      switch self {
      case .FirstSetup:
        return "Setup reef"
      case .Germinate:
        return "Germinate seed"
      case .Cycle:
        return "Cycle tank"
      case .AddFish:
        return "Add fish"
      case .Seedling:
        return "Seedling"
      case  .Vegetative:
        return "Vegetative"
      case .Flowering:
        return "Flowering"
      case .Harvest:
        return "Harvest"
      case .Drying:
        return "Drying"
      case .PrepareNew:
        return "Prepare new grow"
      }
    }

    func numberOfTasks() -> Int {
      switch self {
      case .FirstSetup:
        return 2
      case .Germinate:
        return 3
      case .Cycle:
        return 0
      case .AddFish:
        return 1
      case .Seedling:
        return 0
      case  .Vegetative:
        return 0
      case .Flowering:
        return 0
      case .Harvest:
        return 1
      case .Drying:
        return 0
      case .PrepareNew:
        return 3
      }
    }
  }
  
  struct GrowTracker {
    
    var isFirstGrow: Bool
    var currentStep: Int
    var tasksComplete: Int
    
    // Steps involved for first time reef grower
    var firstGrowSteps: [GrowStep]
    
    // Steps involved for all grows after the first
    var secondaryGrowSteps: [GrowStep]
    
    // Initialize starting values
    init() {
      isFirstGrow = true
      currentStep = 0
      tasksComplete = 0
      firstGrowSteps = [.FirstSetup(nil), .Germinate(nil), .Cycle(nil), .AddFish(nil), .Seedling(nil),
                        .Vegetative(nil), .Flowering(nil), .Harvest(nil), .Drying(nil) ]
      secondaryGrowSteps = [.PrepareNew(nil), .Germinate(nil), .Seedling(nil), .Vegetative(nil),
                            .Flowering(nil), .Harvest(nil), .Drying(nil)]
    }
    
    // Returns number of steps for the current grow
    func getNumberSteps() -> Int {
      if isFirstGrow { return firstGrowSteps.count
      } else { return secondaryGrowSteps.count }
    }
    
    func getStepNames() -> [String] {
      var stepNames: [String] =  []
      if isFirstGrow { for step in firstGrowSteps {  stepNames.append(step.name()) }
      } else { for step in secondaryGrowSteps { stepNames.append(step.name()) }}
      return stepNames
    }
    
  }
  
  /// Retrieves the data associated with the users progress in their current grow cycle
  /// - Returns: Array of GrowStepData for easy access/display on dashboard
  func getGrowStepData() -> [GrowStepData] {
    
    var growSteps: [GrowStepData] = []
    let tasksComplete = growTracker.tasksComplete
    var growStepArr: [GrowStep] = []
    
    if growTracker.isFirstGrow { growStepArr = growTracker.firstGrowSteps
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
    var taskStatus = StepStatus.Future
    let currentStep = growTracker.currentStep
    if index < currentStep { taskStatus = StepStatus.Completed
    } else if index == currentStep { taskStatus = StepStatus.InProgress
    } else { taskStatus = StepStatus.Future }
    return taskStatus
  }
    
}

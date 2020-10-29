//
//  ReefData.swift
//  reef
//
//  Created by Conor Sheehan on 8/6/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
  struct SensorData {
    var waterLevel: [(stored: Date, value: Double)] = []
    var plantHeight: [(stored: Date, value: Double)] = []
    var pHLevel: [(stored: Date, value: Double)] = []
    var airTemp: [(stored: Date, value: Double)] = []
    var humidity: [(stored: Date, value: Double)] = []
    var waterTemp: [(stored: Date, value: Double)] = []
    
    mutating func reset() {
      self = SensorData()
    }
  }
  
  func readSensorData(completion: @escaping () -> Void) {
    
    sensorDataRef?.observeSingleEvent(of: .value) { (snapshot) in
         
      if let reefDataTree =  snapshot.children.allObjects as? [DataSnapshot] {
         
        for sensorNode in reefDataTree {
             
          if let sensorValues = sensorNode.children.allObjects as? [DataSnapshot] {
            for sensorData in sensorValues {
              if let sensorValue = sensorData.value as? Double {
                let dateAdded = sensorData.key.convertStringToDate()
                  self.storeSensorData(branch: sensorNode.key, dateAdded: dateAdded, sensorValue: sensorValue)
                }
              }
            }
          }
        completion()
      }
    }
  }
  
  func storeSensorData(branch: String, dateAdded: Date, sensorValue: Double) {
    switch branch {
    case SensorBranch.waterLevel.rawValue:
      self.sensorData.waterLevel.append((stored: dateAdded, value: sensorValue))
    case SensorBranch.plantHeight.rawValue:
      self.sensorData.plantHeight.append((stored: dateAdded, value: sensorValue))
    case SensorBranch.airTemp.rawValue:
      self.sensorData.airTemp.append((stored: dateAdded, value: sensorValue))
    case SensorBranch.humidity.rawValue:
      self.sensorData.humidity.append((stored: dateAdded, value: sensorValue))
    case SensorBranch.waterTemp.rawValue:
      self.sensorData.waterTemp.append((stored: dateAdded, value: sensorValue))
    default:
      self.sensorData.pHLevel.append((stored: dateAdded, value: sensorValue))
    }
  }
    
}

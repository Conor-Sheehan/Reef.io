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
  
  struct ReefData {
    var waterLevel: [(stored: Date, value: Double)] = []
    var plantHeight: [(stored: Date, value: Double)] = []
    var pH: [(stored: Date, value: Double)] = []
    var airTemp: [(stored: Date, value: Double)] = []
    var humidity: [(stored: Date, value: Double)] = []
    var waterTemp: [(stored: Date, value: Double)] = []
    var currSensorData: [Double] = [0, 0, 0, 0, 0, 0]
  }
  
  func readReefData(completion: @escaping () -> Void) {
    
     reefDataRef?.observeSingleEvent(of: .value) { (snapshot) in
         
          if let reefDataTree =  snapshot.children.allObjects as? [DataSnapshot] {
         
           for sensorNode in reefDataTree {
             
             if let sensorValues = sensorNode.children.allObjects as? [DataSnapshot] {
               for sensorData in sensorValues {
                 if let sensorValue = sensorData.value as? Double {
                  let dateAdded = sensorData.key.convertStringToDate()
                  self.storeReefData(sensor: sensorNode.key, dateAdded: dateAdded, sensorValue: sensorValue)
                 }
               }
             }
           }
           completion()
         }
       }
  }
  
  func storeReefData(sensor: String, dateAdded: Date, sensorValue: Double) {
    switch sensor {
    case "airTemp":
      self.reefData.airTemp.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[3] = sensorValue
    case "humidity":
      self.reefData.humidity.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[4] = sensorValue
    case "plantHeight":
      self.reefData.plantHeight.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[1] = sensorValue
    case "waterLevel":
      self.reefData.waterLevel.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[0] = sensorValue
    case "waterTemp":
      self.reefData.waterLevel.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[5] = sensorValue
    default:
      self.reefData.pH.append((stored: dateAdded, value: sensorValue))
      self.reefData.currSensorData[2] = sensorValue
    }
  }
  
  func getCurrentSensorData() -> [SensorData] {
    var sensorData: [SensorData] = []
    for (index, value) in reefData.currSensorData.enumerated() {
      sensorData.append(SensorData(value: String(value), index: index))
    }
    return sensorData
  }
    
}

//
//  FirebaseReader.swift
//  reef
//
//  Created by Conor Sheehan on 8/26/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {
  
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
    
  // Takes a user's ReefID and returns if it is a valid reef ID
  func validateReefID(with reefID: String, completion: @escaping (_ isValid: Bool) -> Void) {

    var validIDs: [String] = []

    databaseRef?.child("ReefID").child("ValidIDs").observeSingleEvent(of: .value) { (snapshot) in

      if let children =  snapshot.children.allObjects as? [DataSnapshot] {

        for child in children { validIDs.append(child.key) }
        completion(self.containsValidReefID(reefID: reefID, validIDs: validIDs))
      }
    }
  }
  
  
  // Reads Grow Tracker data from firebase
  func readGrowTrackerData(completion: @escaping () -> Void) {
    
    readCurrentGrowData(completion: {
      self.growTrackerRef?.observeSingleEvent(of: .value) { (snapshot) in
              
        if let growTrackerTree =  snapshot.children.allObjects as? [DataSnapshot] {
          for data in growTrackerTree {
            if let trackerData = data.value as? Int {
              self.storeGrowTrackerData(branch: data.key, trackerData: trackerData)
            }
          }
          completion()
        }
      }
    })
  }
  
  // Reads all current grow data from Firebase
  func readCurrentGrowData(completion: @escaping () -> Void) {
    
    let currGrowRef = growTrackerRef?.child("AllGrows").child(String(growTracker.completedGrows))
    
    currGrowRef?.observeSingleEvent(of: .value) { (snapshot) in
      if let currGrowTree =  snapshot.children.allObjects as? [DataSnapshot] {
         for data in currGrowTree {
           if let growData = data.value as? String {
            self.storeCurrentGrowData(branch: data.key, data: growData)
          }
        }
        print("Current grow data", self.currentGrowData)
      }
    }
    
    ecosystemRef?.child(EcosystemBranch.setup.rawValue).observeSingleEvent(of: .value) { (snapshot) in
      if let setup = snapshot.value as? String {
        self.currentGrowData.ecosystemSetup = setup.convertStringToDate()
        print("Setup", setup)
        completion()
      }
    }
  }
  
  // Reads the current water level in the reef grow system during the tank fill process
  func readWaterLevel(completion: @escaping (Int) -> Void) {
    reefSettingsRef?.child("waterLevel").observe(.value, with: { (snapshot) in
      if let waterLevel = snapshot.value as? Int {
        completion(waterLevel)
      }
    })
  }
  
  func readWiFiStatus(completion: @escaping () -> Void) {

    // Check if user has been authorized by firebase
    if let firebaseID = userUID {
      let wifiPathRef = databaseRef?.child("Users").child(firebaseID).child("Reef").child("WiFiLastConnected")
      // Begin reading path
      wifiPathRef?.observe(.value, with: { (snapshot) in
        if (snapshot.value as? String) != nil {
          completion()
        } else { print("WiFi not yet connected") }
      })
    }
  }
  
}

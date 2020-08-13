//
//  AppBrain.swift
//  Reef
//
//  Created by Conor Sheehan on 8/18/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import Firebase

class AppBrain {

  let UDkeys = UserDefaultKeys()
  let defaults = UserDefaults.standard

  // Stores all userDefault key Strings for deep internal storage
  struct UserDefaultKeys {
  }

  // Firebase ACcess
  var userUID = Auth.auth().currentUser?.uid // User's firebase Unique Identifier
  
  enum GrowTrackerBranch: String { case currentStep, tasksComplete, allGrows = "AllGrows", completedGrows }
  
  enum EcosystemBranch: String { case setup, addedFish }
  
  enum AllGrowsBranch: String { case germinated, seedling, vegetative, flowering, harvest, drying, complete }
  
  enum SensorBranch: String { case airTemp, humidity, plantHeight, waterLevel, waterTemp }

  // Firebase Database References for quick access to database structures
  var databaseRef: DatabaseReference?
  var userDataRef: DatabaseReference?
  var growTrackerRef: DatabaseReference?
  var sensorDataRef: DatabaseReference?
  var ecosystemRef: DatabaseReference?
  var reefSettingsRef: DatabaseReference?

  /// REEF DATA STRUCTS
  var userData = UserData()
  var sensorData = SensorData()
  var growTracker = GrowTracker()

  // WiFi connected variable
  var wifiConnected = false

  // Initialize() will retrieve all data from storage when app returns from terminated state
  func initialize() {

    if let firebaseID = userUID {
      databaseRef = Database.database().reference()
      userDataRef = Database.database().reference().child("Users").child(firebaseID).child("UserData")
      sensorDataRef = Database.database().reference().child("Users").child(firebaseID).child("Reef").child("Data")
      growTrackerRef = Database.database().reference().child("Users").child(firebaseID).child("GrowTracker")
      ecosystemRef = Database.database().reference().child("Users").child(firebaseID).child("Ecosystem")
      reefSettingsRef = Database.database().reference().child("Users").child(firebaseID).child("Reef").child("Settings")
    }

    self.readWiFiConnected()
  }
  
  func readWiFiConnected() {

    // Check if user has been authorized by firebase
    if let firebaseID = userUID {

      // Begin reading path
      databaseRef?.child("Users").child(firebaseID).child("WiFiLastConnected").observe(.value, with: { (snapshot) in
        if let connectionTime = snapshot.value as? String {
          print("WiFi connected successfully", connectionTime)
          self.wifiConnected = true
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
        } else { print("WiFi not yet connected") }
      })
    }
  }

    /// Returns whether or not user's Reef has successfully conneected to WiFi
    func getWifiConnected() -> Bool {
        return wifiConnected
    }

}

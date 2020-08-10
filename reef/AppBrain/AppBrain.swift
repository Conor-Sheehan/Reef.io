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
      //let growStarted          =    "GrowStarted"
  }

  // Firebase ACcess
  var userUID = Auth.auth().currentUser?.uid // User's firebase Unique Identifier

  // Firebase Database References for quick access to database structures
  var databaseRef: DatabaseReference?
  var reefSettingsRef: DatabaseReference?
  var userDataRef: DatabaseReference?
  var growDataRef: DatabaseReference?
  var reefDataRef: DatabaseReference?

  /// REEF DATA STRUCTS
  
  // Initialize ReefSettings Struct for storing/retrieving settings data
  //var reefSettings = ReefSettings()
  var userData = UserData()
  var reefData = ReefData()
  var growTracker = GrowTracker()

  // WiFi connected variable
  var wifiConnected = false

  // Initialize() will retrieve all data from storage when app returns from terminated state
  func initialize() {

    if let firebaseID = userUID {
      databaseRef = Database.database().reference()
      reefSettingsRef = Database.database().reference().child("Users").child(firebaseID).child("ReefSettings")
      userDataRef = Database.database().reference().child("Users").child(firebaseID).child("UserData")
      growDataRef = Database.database().reference().child("Users").child(firebaseID).child("GrowData")
      reefDataRef = Database.database().reference().child("Users").child(firebaseID).child("Reef").child("Data")
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

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
  let Defaults = UserDefaults.standard
  
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
  
  
  /// REEF DATA STRUCTS
  
  // Initialize ReefSettings Struct for storing/retrieving settings data
  var reefSettings = ReefSettings()
  var userData = UserData()
  var growData = GrowData()
  
  
  // Home Page Data
  var percentStage: Double = 0.0
  var seedlingStartDate: Date?
  
  // Ecosystem Analytics Data
  var currentPlantHeight: Int = 0
  var currentPH: String = "7.5"
  
  // WiFi connected variable
  var wifiConnected = false
  
  // Initialize() will retrieve all data from storage when app returns from terminated state
  func initialize() {
  
      
    if let firebaseID = userUID {
      databaseRef = Database.database().reference()
      reefSettingsRef = Database.database().reference().child("Users").child(firebaseID).child("ReefSettings")
      userDataRef = Database.database().reference().child("Users").child(firebaseID).child("UserData")
      growDataRef = Database.database().reference().child("Users").child(firebaseID).child("GrowData")
    }
      
    self.readReefSettings()
    self.readWiFiConnected()
  }

  
  /// Takes a user's ReefID and validates
  func validReefID(with ReefID: String, completion: @escaping (_ isValid: Bool) -> Void) {
    
    var validIDs: [String] = []
    
    
    databaseRef?.child("ReefID").child("ValidIDs").observeSingleEvent(of: .value) { (snapshot) in
  
      for child in snapshot.children.allObjects as! [DataSnapshot] {
        validIDs.append(child.key)
      }
      
      if validIDs.contains(ReefID) {
        print("Valid ID's contains ReefID!")
        //  Store key value pairing with user's UID
        self.databaseRef?.child("ReefID").child(ReefID).setValue(self.userUID)
        completion(true)
      }
      else {
        print("Valid ID's does not contain ReefID :(")
        completion(false)
      }
    }
    

  }
    
    
    
    /// Returns the progress of the ecosystem bio-filter (180 day cycle) as a Double
    func getEcosystemProgress() -> Float {
        
        // Get date that the user first filled the water in their Reef
        if let ecosystemStarted = growData.ecosystemStarted {
            
            // Calculate # of days since ecosystem was first established
            let daysSinceEcosystemStarted = ecosystemStarted.daysElapsed()
            
            if daysSinceEcosystemStarted < 180 { return Float(daysSinceEcosystemStarted)/180.0 }
            else { return 1.0 }
        }
        else { return 0.0 }
    }
    
    
    
    /// Returns whether or not user's Reef has successfully conneected to WiFi
    func getWifiConnected() -> Bool {
        return wifiConnected
    }
    
    

    

    

}

//
//  UserDataExt.swift
//  Reef
//
//  Created by Conor Sheehan on 1/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import Firebase

extension AppBrain {

  struct UserData {
    var firstName: String? // Value of user's first name (stored when user registered)
    var fcmToken: String? // Value of user's Firebase Cloud Messaging Token (used for push notifications)
    var email = Auth.auth().currentUser?.email
    var reefID: String?
  }

  /// Stores user's first name in the database for future reference and personalization of profile
  func setFirstName(name: String) {
    userData.firstName = name
    userDataRef?.child("firstName").setValue(name)
  }

  /// Stores user's Firebase Cloud Messaging Token, which is used  to send push notifications to user's device
  func setFCMToken(token: String) {
    userData.fcmToken = token
    userDataRef?.child("fcmToken").setValue(token)
  }

  /// Stores user's unique Reef Ecosystem ID in the Firebase (Used to sync Reef's Hardware to user's database)
  /// - Parameter reefID: User's unique Reef Ecosystem ID (engraved on Reef Ecosystem)
  func storeReefID(reefID: String) {
    if let firebaseID = userUID {
      databaseRef?.child("ReefID").child(reefID).setValue(firebaseID)
    }
  }
  
  func updateTimezone() {
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    reefSettingsRef?.child("timeZone").setValue(secondsFromGMT)
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    userDataRef?.child("timeZone").setValue(localTimeZoneAbbreviation)
  }
  
  func containsValidReefID(reefID: String, validIDs: [String]) -> Bool {
    if validIDs.contains(reefID) {
       print("Valid ID's contains ReefID!")
       //  Store key value pairing with user's UID
       self.databaseRef?.child("ReefID").child(reefID).setValue(self.userUID)
       return true
     } else {
       print("Valid ID's does not contain ReefID :(")
       return false
    }
  }
}

// Firebase reader
extension AppBrain {
  
  // Takes a user's ReefID and returns if it is a valid reef ID
  func validateReefID(with reefID: String, completion: @escaping (_ isValid: Bool) -> Void) {

    var validIDs: [String] = []

    databaseRef?.child("ReefID").child("ValidIDs").observeSingleEvent(of: .value) { (snapshot) in

      if let children =  snapshot.children.allObjects as? [DataSnapshot] {
        
        // Iterate over reefID tree and add all of the valid reefIDs to the local array
        for child in children { validIDs.append(child.key) }
        
        completion(self.containsValidReefID(reefID: reefID, validIDs: validIDs))
      }
    }
  }
  
}

//
//  UserDataExt.swift
//  Reef
//
//  Created by Conor Sheehan on 1/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
    
    struct UserData {
        
        // Value of user's first name (stored when user registered)
        var firstName: String?
        
        // Number of Grows user has completed with Reef
        var growsWithReef: Int = 0
        
        // Value of user's Firebase Cloud Messaging Token (used for push notifications)
        var fcmToken: String?
        
    }
    
    /// Stores user's first name in the database for future reference and personalization of profile
    func setFirstName(name: String) {
        userData.firstName = name
        userDataRef?.child("firstName").setValue(name)
    }
    
    /// Stores user's Firebase Cloud Messaging Token, which is used by cloud functions to send push notifications to user's device
    func setFCMToken(token: String) {
        userData.fcmToken = token
        userDataRef?.child("fcmToken").setValue(token)
    }
    
    /// Stores user's unique Reef Ecosystem ID in the Firebase (Used to sync Reef's Wi-Fi receiver to the user's database)
    /// - Parameter reefID: User's unique Reef Ecosystem ID (engraved on Reef Ecosystem)
    func storeReefID(reefID: String) {
        if let firebaseID = userUID {
            databaseRef?.child("ReefID").child(reefID).setValue(firebaseID)
        }
    }
    
    
    
    
}

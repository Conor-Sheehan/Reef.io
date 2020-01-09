//
//  FirebaseWriter.swift
//  Reef
//
//  Created by Conor Sheehan on 9/11/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import Foundation

// EXTENSION FOR STORING DATA IN FIREBASE
extension AppBrain {
    
    
    func storeEcosystemStartDate() {
        let currentDate = Date()
        
        if let firebaseID = userUID {
            databaseRef.child("Users").child(firebaseID).child("GrowDates").child("EcosystemStartDate").setValue(self.convertDateToString(date: currentDate))
            self.ecosystemStartDate = currentDate
        }
    }
    
    func storeSeedlingStartDate() {
        // Store the Grow start date in the database
        let currentDate = Date()
        
        if let firebaseID = userUID {
            databaseRef.child("Users").child(firebaseID).child("GrowDates").child("SeedlingStartDates").child(self.convertDateToString(date: currentDate)).setValue("Started")
            self.seedlingStartDate = currentDate
        }
    }
    
    /// Stores the updated basin levels
    func storeBasinLevels(nutrientLevel: Int, PHDownLevel: Int, PHUpLevel: Int) {
    
        if let firebaseID = userUID {
            if nutrientLevel >= 0   { databaseRef.child("Users").child(firebaseID).child("BasinLevels").child("Nutrients").setValue(nutrientLevel) }
            if PHDownLevel >= 0     { databaseRef.child("Users").child(firebaseID).child("BasinLevels").child("PhDown").setValue(PHDownLevel) }
            if PHUpLevel >= 0       { databaseRef.child("Users").child(firebaseID).child("BasinLevels").child("PhUp").setValue(PHUpLevel) }
        }
    }
    
    func storeAquariumStatus(full: Int) {
        
         if let firebaseID = userUID {
            userSettingsData[2] =  (full == 1) ? "Full" : "Empty"
            databaseRef.child("Users").child(firebaseID).child("ReefSettings").child("aquariumFull").setValue(full)
        }
    }
    
    /// Stores the user's first name in their Firebase Database Tree (Used for personalizing user's profile)
    /// - Parameter firstName: User's First Name
    func setFirstName(firstName: String) {
        if let firebaseID = userUID {
            userSettingsData[3] = firstName
            databaseRef.child("Users").child(firebaseID).child("UserData").child("FirstName").setValue(firstName)
        }
    }
    
    
    /// Stores user's unique Reef Ecosystem ID in the Firebase (Used to sync Reef's Wi-Fi receiver to the user's database)
    /// - Parameter reefID: User's unique Reef Ecosystem ID (engraved on Reef Ecosystem)
    func storeReefID(reefID: String) {
        if let firebaseID = userUID {
            databaseRef.child("ReefID").child(reefID).setValue(firebaseID)
        }
    }
    
    // Setters for Settings Page Data
    func setGrowMode(GrowMode: String) {
        
        if let firebaseID = userUID {
            userSettingsData[0] = GrowMode
            databaseRef.child("Users").child(firebaseID).child("ReefSettings").child("GrowMode").setValue(GrowMode)
        }
    }
    
    
    /// Stores the time that the user want's their Reef Ecosystem to turn on lights each day
    /// - Parameter SunriseTime: Time each day user wants to turn on grow and aquarium lights
    func setSunriseTime(SunriseTime: String) {
         if let firebaseID = userUID {
            userSettingsData[1] = SunriseTime
            databaseRef.child("Users").child(firebaseID).child("ReefSettings").child("sunrise").setValue(SunriseTime)
        }
    }
    
    
    /// Stores the Aquarium Light's RGB value in Firebase
    /// - Parameter AquariumLRGB: RGB Value of the color for the aquarium led
    func setAquariumLighting(AquariumRGB: String) {
        
        if let firebaseID = userUID {
            databaseRef.child("Users").child(firebaseID).child("ReefSettings").child("AquariumRGB").setValue(AquariumRGB)
        }
    }
    
    func storeMessagingToken(FCMtoken: String) {
        if let firebaseID = userUID {
            databaseRef.child("Users").child(firebaseID).child("UserData").child("FCMtoken").setValue(FCMtoken)
        }
    }

    
}


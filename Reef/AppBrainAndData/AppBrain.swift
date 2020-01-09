//
//  AppBrain.swift
//  Reef
//
//  Created by Conor Sheehan on 8/18/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class AppBrain {
    
    let UDkeys = UserDefaultKeys()
    let Defaults = UserDefaults.standard
    
    struct UserDefaultKeys {
        let growStarted          =    "GrowStarted"
        let dailyReminderTime    =    "dailyPillTime"
    }
    
    // Firebase Data
    internal var userUID = Auth.auth().currentUser?.uid
    internal var databaseRef = Database.database().reference()
    
    // Settings Page Data
    internal var navigatingTo = ""
    internal var growStarted = false
    
    // SETTINGS PAGE DATA: [Grow Mode, Sunrise Time, Aquarium Status, FirstName]
    internal var userSettingsData: [String] = ["Auto-Flower","9:00 AM","Empty", "Name"]
    
    // Home Page Data
    internal var percentStage: Double = 0.0
    internal var seedlingStartDate: Date?
    internal var ecosystemStartDate: Date?
    internal var growsWithReef: Int = 0
    internal var growStage: Int = 0
    
    // Ecosystem Analytics Data
    internal var currentPlantHeight: Int = 0
    internal var currentPH: String = "7.5"
    
    //Basin Level Data [NUTRIENTS, PH DOWN, PH UP]
    internal var basinLevels: [Int] = [0,0,0]
    
    // WiFi connected variable
    internal var wifiConnected = false

    
    // Initialize() will retrieve all data from storage when app returns from terminated state
    func initialize() {
        
        growStarted = Defaults.bool(forKey: UDkeys.growStarted)
    
        self.readUserSettings()
        self.readGrowData()
        self.readBasinLevels()
        self.readSensorData()
        self.readWiFiConnected()
    }
    
    
    func getGrowData() -> (percentStage: Double, currentPlantHeight: Int, growStage: Int, growsWithReef: Int, currentPH: String){
        return  (self.percentStage, self.currentPlantHeight, self.growStage, self.growsWithReef, self.currentPH)
    }
    
    /// Returns the progress of the ecosystem bio-filter (180 day cycle) as a Double
    func getEcosystemProgress() -> Float {
        
        // Get date that the user first filled the water in their Reef
        if let ecosystemStarted = ecosystemStartDate {
            
            // Calculate # of days since ecosystem was first established
            let daysSinceEcosystemStarted = self.daysSinceDate(date: ecosystemStarted)
            
            if daysSinceEcosystemStarted < 180 { return Float(daysSinceEcosystemStarted)/180.0 }
            else { return 1.0 }
        }
        else { return 0.0 }
    }
    
    
    /// Returns the unique level of each of Reef's basins
    func getBasinLevels() -> (nutrientLvl: Int, phDownLvl: Int, phUpLvl: Int) {
        return (basinLevels[0], basinLevels[1], basinLevels[2])
    }
    
    
    /// Returns the unique values for all of the data displayed in the Settings Pages
    func getSettings() -> (growMode: String, sunriseTime: String, aquariumStatus: String, firstName: String, navigatingTo: String, growStarted: Bool) {
        return (userSettingsData[0], userSettingsData[1], userSettingsData[2], userSettingsData[3], self.navigatingTo, self.growStarted)
    }
    
    
    
    func setNavigatingTo(NavigatingTo: String) {
        self.navigatingTo = NavigatingTo
    }
    
    func setGrowStartedState(GrowStarted: Bool) {
        self.growStarted = GrowStarted
        
        if GrowStarted { self.storeSeedlingStartDate() }
        
        // Store data in user defaults
        Defaults.set(GrowStarted, forKey: UDkeys.growStarted)
        
        if let firebaseID = userUID {
            // Store data in firebase
            databaseRef.child(firebaseID).child("UserSettings").child("GrowStarted").setValue(GrowStarted)
        }
    }
    
    /// Returns whether or not user's Reef has successfully conneected to WiFi
    func getWifiConnected() -> Bool {
        return wifiConnected
    }
    
    

    

    

}

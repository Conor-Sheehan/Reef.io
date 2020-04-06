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
    
    //Bluetooth message compiler
    internal var compiledData: String = ""
    
    // Initialize() will retrieve all data from storage when app returns from terminated state
    func initialize() {
        
        growStarted = Defaults.bool(forKey: UDkeys.growStarted)
    
        self.readUserSettings()
        self.readGrowData()
        self.readBasinLevels()
        self.readSensorData()
    }
    
    
    func getGrowData() -> (percentStage: Double, currentPlantHeight: Int, growStage: Int, growsWithReef: Int, currentPH: String){
        return  (self.percentStage, self.currentPlantHeight, self.growStage, self.growsWithReef, self.currentPH)
    }
    
    /// Returns the progress of the ecosystem bio-filter (180 day cycle) as a Double
    func getEcosystemProgress() -> Float {
        if let ecosystemStarted = ecosystemStartDate {
            let daysSinceEcosystemStarted = self.daysSinceDate(date: ecosystemStarted)
            
            if daysSinceEcosystemStarted < 180 { return Float(daysSinceEcosystemStarted)/180.0 }
            else { return 1.0 }
        }
        else { return 0.0 }
    }
    
    /// Returns the integer value levels of Reef's basins
    func getBasinLevels() -> (nutrientLvl: Int, phDownLvl: Int, phUpLvl: Int) {
        return (basinLevels[0], basinLevels[1], basinLevels[2])
    }
    

    func getSettings() -> (growMode: String, sunriseTime: String, aquariumStatus: String, firstName: String, navigatingTo: String, growStarted: Bool) {
        return (userSettingsData[0], userSettingsData[1], userSettingsData[2], userSettingsData[3], self.navigatingTo, self.growStarted)
    }
    
    
    // Setters for Settings Page Data
    func setGrowMode(GrowMode: String) {
        userSettingsData[0] = GrowMode
        databaseRef.child(userUID!).child("UserSettings").child("GrowMode").setValue(GrowMode)
    }
    
    func setSunriseTime(SunriseTime: String){
        userSettingsData[1] = SunriseTime
        databaseRef.child(userUID!).child("UserSettings").child("SunriseTime").setValue(SunriseTime)
    }
    func setAquariumLighting(AquariumLighting: String){
        databaseRef.child(userUID!).child("UserSettings").child("AquariumLighting").setValue(AquariumLighting)
    }
    
    
    func setAquariumStatus(status: String){
        userSettingsData[2] = status
        databaseRef.child(userUID!).child("UserSettings").child("AquariumStatus").setValue(status)
    }
    
    func setNavigatingTo(NavigatingTo: String) {
        self.navigatingTo = NavigatingTo
    }
    
    func setGrowStartedState(GrowStarted: Bool) {
        self.growStarted = GrowStarted
        
        if GrowStarted { self.storeSeedlingStartDate() }
        
        // Store data in user defaults
        Defaults.set(GrowStarted, forKey: UDkeys.growStarted)
        // Store data in firebase
        databaseRef.child(userUID!).child("UserSettings").child("GrowStarted").setValue(GrowStarted)
    }
    
    func setFirstName(firstName: String) {
        userSettingsData[3] = firstName
        databaseRef.child(userUID!).child("UserSettings").child("FirstName").setValue(firstName)
    }
  
  func setFCMToken(token: String) {
    databaseRef.child(userUID!).child("UserData").child("FCMtoken").setValue(token)
  }
    

    

}

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
        let dailyReminderTime      =    "dailyPillTime"
    }
    
    // Firebase Data
    internal var userUID = Auth.auth().currentUser?.uid
    internal var databaseRef = Database.database().reference()
    
    // Settings Page Data
    internal var navigatingTo = ""
    internal var growStarted = false
    
    // SETTINGS PAGE DATA: [Grow Mode, Sunrise Time, Aquarium Status, Grow Started]
    internal var settingsData: [String] = ["Auto-Flower","9:00 AM","Empty"]
    
    // Home Page Data
    internal var percentStage: Double = 0.0
    internal var seedlingStartDate: Date?
    internal var ecosystemStartDate: Date?
    internal var growStage: Int = 0
    
    // Ecosystem Analytics Data
    internal var currentPlantHeight: Int = 0
    
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
    }
    
    
    func getGrowData() -> (percentStage: Double, currentPlantHeight: Int, growStage: Int){
        return  (self.percentStage, self.currentPlantHeight, self.growStage)
    }
    
    /// Returns the integer value levels of Reef's basins
    func getBasinLevels() -> (nutrientLvl: Int, phDownLvl: Int, phUpLvl: Int) {
        return (basinLevels[0], basinLevels[1], basinLevels[2])
    }
    

    func getSettings() -> (growMode: String, sunriseTime: String, aquariumStatus: String, navigatingTo: String, growStarted: Bool) {
        return (settingsData[0], settingsData[1], settingsData[2], self.navigatingTo, self.growStarted)
    }
    
    
    // Setters for Settings Page Data
    func setGrowMode(GrowMode: String) {
        settingsData[0] = GrowMode
        databaseRef.child(userUID!).child("UserSettings").child("GrowMode").setValue(GrowMode)
    }
    
    func setSunriseTime(SunriseTime: String){
        settingsData[1] = SunriseTime
        databaseRef.child(userUID!).child("UserSettings").child("SunriseTime").setValue(SunriseTime)
    }
    func setAquariumLighting(AquariumLighting: String){
        databaseRef.child(userUID!).child("UserSettings").child("AquariumLighting").setValue(AquariumLighting)
    }
    
    
    func setAquariumStatus(status: String){
        settingsData[2] = status
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
    

    

}

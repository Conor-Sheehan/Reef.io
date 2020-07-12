//
//  ReefSettingsExt.swift
//  Reef
//
//  Created by Conor Sheehan on 1/23/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation


/// EXTENSION FOR HANDLING REEF ECOSYSTEM SETTINGS
extension AppBrain {
    
    
    // Used to access basinLevels with ease (e.g basinLevels[basin.Names.Nutrients.rawValue )
    public enum BasinName : String { case nutrients, phDown, phUp}
    
    // All possible grow stages Reef can be set to
    public enum GrowStage: String { case inactive, germinating, seedling, vegetative, flowering, drying }
    
    
    // Stores all primary settings for Reef Ecosystem
    struct ReefSettings {
        
        // Amount of hours that growlight is turned ON for each GrowStage
        let dayHours: Dictionary = [ GrowStage.inactive : 0, GrowStage.germinating: 0, GrowStage.seedling: 18,
        GrowStage.vegetative: 18, GrowStage.flowering: 12, GrowStage.drying: 0 ]
        
        // Aquarium Settings
        var aquariumFull: Bool = false                                  // True if user has filled the aquarium with water, false otherwise
        var aquariumRGB: String = "255,255,255"                         // RGB Value of color for aquarium RGB LED light
        var basinLevels = ["nutrients" : 0, "phDown" : 0, "phUp": 0]    // (Integer-valued) Liquid levels of solution basins in Reef
        
        // Light Settings
        var sunrise: String?                                            // Time in military that Reef is set to turn on lights (Aquaruim AND GrowLight)
        
        // Stores current Grow Stage for user's plant (initialized as inactive grow)
        var growStage: GrowStage = .inactive
        
        func activeGrow() -> Bool {
            if growStage == .inactive { return false }
            else { return true }
        }
        
    }
    
    
    /// SETS new GrowStage and stores updated data in Firebase
    func setGrowStage(stage: GrowStage) {
        // Update current grow stage (GrowStages can be updated from the App-Client Side besides .vegetative)
        reefSettings.growStage = stage
        
        // Store updated GROW STAGE and DAY HOURS in Firebase
        reefSettingsRef?.child("growStage").setValue(stage.rawValue)
        reefSettingsRef?.child("dayHours").setValue(reefSettings.dayHours[stage])
    }
    
    
    /// Updates the basin levels in Reef's Settings when user refills solution basins
    /// - Parameters:
    ///   - nutrients: Liquid level of nutrients (0  >  && < 80)
    ///   - phDown: Liquid level of phDown (0 >  &&  < 80)
    ///   - phUp: Liquid level of phUP (0 >  && < 80)
    func setBasinLevels(nutrients: Int, phDown: Int, phUp: Int) {
        
        // if liquid level is valid, then update basinlevel dictionary and store value in firebase
        if ( nutrients >= 0 && nutrients <= 80 ) {
            reefSettings.basinLevels[BasinName.nutrients.rawValue] = nutrients
            reefSettingsRef?.child("BasinLevels").child("nutrients").setValue(nutrients)
        }
        if ( phDown >= 0 && phDown <= 80 ) {
            reefSettings.basinLevels[BasinName.phDown.rawValue] = phDown
            reefSettingsRef?.child("BasinLevels").child("phDown").setValue(phDown)
        }
        if ( phUp >= 0 && phUp <= 80 ) {
            reefSettings.basinLevels[BasinName.phUp.rawValue] = phUp
            reefSettingsRef?.child("BasinLevels").child("phUp").setValue(phUp)
        }
            
    }
    
    /// Sets the Aquarium Level to true if it has been filled with water, false otherwise
    func setAquariumLevel(full: Bool) {
        reefSettings.aquariumFull = full
        
        // Store aquaruim Filled value in Firebase (1 if full, 0 otherwise)
        let filled = full ? 1 : 0
        reefSettingsRef?.child("aquariumFull").setValue(filled)
    }
    
    /// Sets the Sunrise Time that Reef will use to turn on lights each day
    func setSunrise(time: String) {
        reefSettings.sunrise = time
        reefSettingsRef?.child("sunrise").setValue(time)
    }
    
    
    
    
    
    // FIREBASE READING AND EVENT LISTENERS
    
    /// FIREBASE: Reads the current levels of Reef's basins from Firebase
    func readReefSettings() {
            
        
        // Read and setup listeners for ALL BASIN LEVELS FROM REEF
        reefSettingsRef?.child("BasinLevels").child("nutrients").observe(.value) { (snapshot) in
            if let nutrientLvl = snapshot.value as? Int {
                self.reefSettings.basinLevels[BasinName.nutrients.rawValue] = nutrientLvl
            }
        }
        
        reefSettingsRef?.child("BasinLevels").child("phDown").observe(.value) { (snapshot) in
           if let phDownLvl = snapshot.value as? Int {
                self.reefSettings.basinLevels[BasinName.phDown.rawValue] = phDownLvl
           }
        }
        
        reefSettingsRef?.child("BasinLevels").child("phUp").observe(.value) { (snapshot) in
           if let phUpLvl = snapshot.value as? Int {
               self.reefSettings.basinLevels[BasinName.phUp.rawValue] = phUpLvl
           }
       }
        
        
        // Read and setup listener for if aquarium is full
        reefSettingsRef?.child("aquariumFull").observe(.value) { (snapshot) in
            if let aqrmFull = snapshot.value as? Int {
                self.reefSettings.aquariumFull = aqrmFull  == 1 ? true : false
            }
        }
        
        // Read and setup listener for aquarium RGB color
       reefSettingsRef?.child("aquariumRGB").observe(.value) { (snapshot) in
           if let aqrRGB = snapshot.value as? String {
               self.reefSettings.aquariumRGB = aqrRGB
           }
       }
        
        reefSettingsRef?.child("growStage").observe(.value) { (snapshot) in
          if let grwStage = snapshot.value as? String {
            self.reefSettings.growStage = GrowStage(rawValue: grwStage)
          }
        }
        
        reefSettingsRef?.child("sunrise").observe(.value) { (snapshot) in
          if let snrs = snapshot.value as? String {
            self.reefSettings.sunrise = snrs
          }
        }
            
    }
    
    
    
    
}

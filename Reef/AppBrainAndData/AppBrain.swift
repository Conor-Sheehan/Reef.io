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
    
    // Settings Page Data
    private var growMode = "Auto-Flower"
    private var sunriseTime = "9:00 AM"
    private var aquariumLighting = "Ocean"
    private var feederMode = "Auto"
    private var navigatingTo = ""
    private var userUID = Auth.auth().currentUser?.uid
    private var databaseRef = Database.database().reference()
    private var growStarted = false
    private var growStartedText = "Start Grow"
    
    // Home Page Data
    private var currentDayCountInStage: Int = 0
    private var daysUntilNextStage: Int = 0
    var seedlingStartDate: Date?
    private var ecosystemStartDate: Date?
    
    // Initialize() will retrieve all data from storage when app returns from terminated state
    func initialize(){
        self.storeUserSettings()
        self.storeGrowDates()
        
  
        
    }
    
    func storeGrowDates(){
        databaseRef.child("GrowDates").child(userUID!).child("SeedlingStartDate").observeSingleEvent(of: .value){ (snapshot) in
            if let seedlingStartedDate = snapshot.value as? String {
                self.seedlingStartDate = self.convertStringToDate(str: seedlingStartedDate)
                self.currentDayCountInStage = self.daysInStage()
                print("Days in current grow stage ", self.currentDayCountInStage)
            }
        }
    }
    
    func storeUserSettings(){
        databaseRef.child("UserSettings").child(userUID!).child("GrowMode").observeSingleEvent(of: .value){ (snapshot) in
            if let GrowMode = snapshot.value as? String {
                self.growMode = GrowMode
            }
        }
        databaseRef.child("UserSettings").child(userUID!).child("SunriseTime").observeSingleEvent(of: .value){ (snapshot) in
            if let SunriseTime = snapshot.value as? String {
                self.sunriseTime = SunriseTime
            }
        }
        databaseRef.child("UserSettings").child(userUID!).child("AquariumLighting").observeSingleEvent(of: .value){ (snapshot) in
            if let AquariumLighting = snapshot.value as? String {
                self.aquariumLighting = AquariumLighting
            }
        }
        databaseRef.child("UserSettings").child(userUID!).child("FeederMode").observeSingleEvent(of: .value){ (snapshot) in
            if let FeederMode = snapshot.value as? String {
                self.feederMode = FeederMode
            }
        }
        databaseRef.child("UserSettings").child(userUID!).child("GrowStarted").observeSingleEvent(of: .value){ (snapshot) in
            if let growStarted = snapshot.value as? Bool {
                
                if(growStarted){
                    self.growStarted = true
                    self.growStartedText = "End Grow"
                }
                else{
                    self.growStarted = false
                    self.growStartedText = "Start Grow"
                }
            }
        }
    }
    
    func getSettings() -> (growMode: String, sunriseTime: String, aquariumLighting: String, feederMode: String, navigatingTo: String, growStartedText: String) {
        return (self.growMode, self.sunriseTime, self.aquariumLighting, self.feederMode, self.navigatingTo, self.growStartedText)
    }
    
    func setGrowMode(GrowMode: String){
        self.growMode = GrowMode
        databaseRef.child("UserSettings").child(userUID!).child("GrowMode").setValue(GrowMode)
    }
    
    func setSunriseTime(SunriseTime: String){
        self.sunriseTime = SunriseTime
        databaseRef.child("UserSettings").child(userUID!).child("SunriseTime").setValue(SunriseTime)
    }
    func setAquariumLighting(AquariumLighting: String){
        self.aquariumLighting = AquariumLighting
        databaseRef.child("UserSettings").child(userUID!).child("AquariumLighting").setValue(AquariumLighting)
    }
    func setFeederMode(FeederMode: String){
        self.feederMode = FeederMode
        databaseRef.child("UserSettings").child(userUID!).child("FeederMode").setValue(FeederMode)
    }
    
    func setNavigatingTo(NavigatingTo: String){
        self.navigatingTo = NavigatingTo
    }
    
    func setGrowStartedState(GrowStarted: Bool){
        self.growStarted = GrowStarted
        if(GrowStarted){
            self.growStartedText = "End Grow"
            self.storeSeedlingStartDate()
        }
        else{
            self.growStartedText = "Start Grow"
        }
        
        databaseRef.child("UserSettings").child(userUID!).child("GrowStarted").setValue(GrowStarted)
    }
    
    func storeEcosystemStartDate(){
        databaseRef.child("GrowDates").child(userUID!).child("EcosystemStartDate").setValue(self.convertDateToString())
        self.ecosystemStartDate = Date()
    }
    
    func storeSeedlingStartDate(){
        // Store the Grow start date in the database
        databaseRef.child("GrowDates").child(userUID!).child("SeedlingStartDate").setValue(self.convertDateToString())
        self.seedlingStartDate = Date()
    }
    

    
    
    
    
}

//
//  FirebaseHandler.swift
//  Reef
//
//  Created by Conor Sheehan on 9/12/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation

// Firebase Extension for reading
extension AppBrain {

    func readGrowData() {
        databaseRef.child("GrowData").child(userUID!).child("CurrentPlantHeight").observeSingleEvent(of: .value) { (snapshot) in
            if let currentPlantHeight = snapshot.value as? Int {
                self.currentPlantHeight = currentPlantHeight
            }
        }
    }

    func readGrowDates() {
        databaseRef.child("GrowDates").child(userUID!).child("SeedlingStartDate").observeSingleEvent(of: .value) { (snapshot) in
            if let seedlingStartedDate = snapshot.value as? String {
                self.seedlingStartDate = self.convertStringToDate(str: seedlingStartedDate)
                self.findGrowStage()
            }
        }

        databaseRef.child("GrowDates").child(userUID!).child("EcosystemStartDate").observeSingleEvent(of: .value) { (snapshot) in
            if let ecosystemStartedDate = snapshot.value as? String {
                self.ecosystemStartDate = self.convertStringToDate(str: ecosystemStartedDate)
                self.ecosystemLife = self.daysSinceDate(date: self.ecosystemStartDate!)
            }
        }
    }

    /// FIREBASE: Reads the current levels of Reef's basins from Firebase
    func readBasinLevels() {

        databaseRef.child("BasinLevels").child(userUID!).child("PhUp").observeSingleEvent(of: .value) { (snapshot) in
            if let phUpLvl = snapshot.value as? Int {
                print("PH UP LEVEL", phUpLvl)
                self.phUpLevel = phUpLvl
            }
        }
        databaseRef.child("BasinLevels").child(userUID!).child("Nutrient").observeSingleEvent(of: .value) { (snapshot) in
            if let nutrientLvl = snapshot.value as? Int {
                print("NUTRIENT LEVEL", nutrientLvl)
                self.nutrientLevel = nutrientLvl
            }
        }
        databaseRef.child("BasinLevels").child(userUID!).child("PhDown").observeSingleEvent(of: .value) { (snapshot) in
            if let phDownLvl = snapshot.value as? Int {
                print("PH DOWN LEVEL", phDownLvl)
                self.phDownLevel = phDownLvl
            }
        }

    }

    func readUserSettings() {
//        databaseRef.child("UserSettings").child(userUID!).child("GrowMode").observeSingleEvent(of: .value){ (snapshot) in
//            if let GrowMode = snapshot.value as? String {
//                self.growMode = GrowMode
//            }
//        }
//        databaseRef.child("UserSettings").child(userUID!).child("SunriseTime").observeSingleEvent(of: .value){ (snapshot) in
//            if let SunriseTime = snapshot.value as? String {
//                self.sunriseTime = SunriseTime
//            }
//        }
//        databaseRef.child("UserSettings").child(userUID!).child("AquariumLighting").observeSingleEvent(of: .value){ (snapshot) in
//            if let AquariumLighting = snapshot.value as? String {
//                self.aquariumLighting = AquariumLighting
//            }
//        }
//        databaseRef.child("UserSettings").child(userUID!).child("FeederMode").observeSingleEvent(of: .value){ (snapshot) in
//            if let FeederMode = snapshot.value as? String {
//                self.feederMode = FeederMode
//            }
//        }
//        databaseRef.child("UserSettings").child(userUID!).child("GrowStarted").observeSingleEvent(of: .value){ (snapshot) in
//            if let growStarted = snapshot.value as? Bool {
//                
//                if growStarted {
//                    self.growStarted = true
//                    self.growStartedText = "End Grow"
//                }
//                else{
//                    self.growStarted = false
//                    self.growStartedText = "Start Grow"
//                }
//            }
//        }
    }

}

// EXTENSION FOR STORING DATA IN FIREBASE
extension AppBrain {

    func storeMostRecentCommunicationDate() {
        let recentCommunication = self.convertDateToString(date: Date())
        databaseRef.child("GrowDates").child(userUID!).child("MostRecentCommunication").child(recentCommunication).setValue("Checked-in w/ Reef")
    }

    func storeEcosystemStartDate() {
        let currentDate = Date()
        databaseRef.child("GrowDates").child(userUID!).child("EcosystemStartDate").setValue(self.convertDateToString(date: currentDate))
        self.ecosystemStartDate = Date()
    }

    func storeSeedlingStartDate() {
        // Store the Grow start date in the database
        let currentDate = Date()
        databaseRef.child("GrowDates").child(userUID!).child("SeedlingStartDate").setValue(self.convertDateToString(date: currentDate))
        self.seedlingStartDate = Date()
    }

    func storeRefilledBasin(basin: Int) {
        print("Refilling basin", basin)
        switch basin {
        case 1:
            databaseRef.child("BasinLevels").child(userUID!).child("Nutrient").setValue(300)
            nutrientLevel = 300
        case 2:
            databaseRef.child("BasinLevels").child(userUID!).child("PhUp").setValue(300)
            phUpLevel = 300
        default:
            databaseRef.child("BasinLevels").child(userUID!).child("PhDown").setValue(300)
            phDownLevel = 300
        }

    }

    /// matches() is a function that returns the substrings that match the regex
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

}

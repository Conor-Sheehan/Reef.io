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
    
    func storeMostRecentCommunicationDate() {
        let recentCommunication = self.convertDateToString(date: Date())
        databaseRef.child(userUID!).child("GrowDates").child("MostRecentCommunication").child(recentCommunication).setValue("Checked-in w/ Reef")
    }
    
    
    func storeEcosystemStartDate() {
        let currentDate = Date()
        databaseRef.child(userUID!).child("GrowDates").child("EcosystemStartDate").setValue(self.convertDateToString(date: currentDate))
        self.ecosystemStartDate = Date()
    }
    
    func storeSeedlingStartDate() {
        // Store the Grow start date in the database
        let currentDate = Date()
        databaseRef.child(userUID!).child("GrowDates").child("SeedlingStartDate").setValue(self.convertDateToString(date: currentDate))
        self.seedlingStartDate = Date()
    }
    
    /// Stores the updated basin levels
    func storeBasinLevels(nutrientLevel: Int, pHDownLevel: Int, pHUpLevel: Int) {
    
        if let firebaseID = userUID {
            if nutrientLevel >= 0   { databaseRef.child(firebaseID).child("BasinLevels").child("Nutrient").setValue(nutrientLevel) }
            if pHDownLevel >= 0     { databaseRef.child(firebaseID).child("BasinLevels").child("PhDown").setValue(pHDownLevel) }
            if pHUpLevel >= 0       { databaseRef.child(firebaseID).child("BasinLevels").child("PhUp").setValue(pHUpLevel) }
        }
    }
    
    
    // storepHData() takes the data sent from Reef and parses it and then stores it in
    // firebase with it's corresponding date that the value was recorded
    func storeDataArrays(data: String) {
        let allData = data.split(separator: "&")
        let pHDataArr = allData[0].split(separator: ",")
        
        if allData.count > 1 {
           
            let pHeightDataArr = allData[1].split(separator: ",")
            print("Parsed plant height data: ", pHeightDataArr)
            
            if pHeightDataArr.count > 0 {
                for index in 0 ... (pHeightDataArr.count - 1) {
                    let hoursAgo = (pHeightDataArr.count - index - 1)*12 // Estimates how many hours ago each data entry was recorded
                    let pHeightDate = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: Date()) // Creates date-time object when data was recorded
                    let dateString = self.convertDateToString(date: pHeightDate!) // Converts date-time object to string for firebase storage
                    
                    databaseRef.child(userUID!).child("plantHeightData").child(dateString).setValue(pHeightDataArr[index])
                    print("Storing plant Height Data: ", pHeightDataArr[index])
                }
            }
            
        }
        
        print("Parsed pH Data Array: ", pHDataArr)
        
        
        // if there is stored pH Data then store it in firebase
        if pHDataArr.count > 1 {
            
            // Iterates through bluetooth communication to store each data entry in Firebase
            for index in 1 ... (pHDataArr.count - 1) {
                let hoursAgo = (pHDataArr.count - index - 1)*12 // Estimates how many hours ago each data entry was recorded
                let pHDate = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: Date()) // Creates date-time object when data was recorded
                let dateString = self.convertDateToString(date: pHDate!) // Converts date-time object to string for firebase storage
                
                databaseRef.child(userUID!).child("pHData").child(dateString).setValue(pHDataArr[index])
                print("Storing pHData: ", pHDataArr[index])
            }
        }
        
    }

    
}


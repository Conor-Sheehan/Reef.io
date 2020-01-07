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
        self.ecosystemStartDate = currentDate
    }
    
    func storeSeedlingStartDate() {
        // Store the Grow start date in the database
        let currentDate = Date()
        databaseRef.child(userUID!).child("GrowDates").child("SeedlingStartDates").child(self.convertDateToString(date: currentDate)).setValue("Started")
        self.seedlingStartDate = currentDate
    }
    
    /// Stores the updated basin levels
    func storeBasinLevels(nutrientLevel: Int, PHDownLevel: Int, PHUpLevel: Int) {
    
        if let firebaseID = userUID {
            if nutrientLevel >= 0   { databaseRef.child(firebaseID).child("BasinLevels").child("Nutrient").setValue(nutrientLevel) }
            if PHDownLevel >= 0     { databaseRef.child(firebaseID).child("BasinLevels").child("PhDown").setValue(PHDownLevel) }
            if PHUpLevel >= 0       { databaseRef.child(firebaseID).child("BasinLevels").child("PhUp").setValue(PHUpLevel) }
        }
    }
    
    
    // storePHData() takes the data sent from Reef and parses it and then stores it in
    // firebase with it's corresponding date that the value was recorded
    func storeDataArrays(data: String) {
        let allData = data.split(separator: "&")
        let PHDataArr = allData[0].split(separator: ",")
        
        if allData.count > 1 {
           
            let PHeightDataArr = allData[1].split(separator: ",")
            print("Parsed plant height data: ", PHeightDataArr)
            
            if PHeightDataArr.count > 0 {
                for index in 0 ... (PHeightDataArr.count - 1) {
                    let hoursAgo = (PHeightDataArr.count - index - 1)*12 // Estimates how many hours ago each data entry was recorded
                    let PHeightDate = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: Date()) // Creates date-time object when data was recorded
                    let dateString = self.convertDateToString(date: PHeightDate!) // Converts date-time object to string for firebase storage
                    
                    databaseRef.child(userUID!).child("plantHeightData").child(dateString).setValue(PHeightDataArr[index])
                    print("Storing plant Height Data: ", PHeightDataArr[index])
                }
            }
            
        }
        
        print("Parsed PH Data Array: ", PHDataArr)
        
        
        // if there is stored PH Data then store it in firebase
        if PHDataArr.count > 1 {
            
            // Iterates through bluetooth communication to store each data entry in Firebase
            for index in 1 ... (PHDataArr.count - 1) {
                let hoursAgo = (PHDataArr.count - index - 1)*12 // Estimates how many hours ago each data entry was recorded
                let PHDate = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: Date()) // Creates date-time object when data was recorded
                let dateString = self.convertDateToString(date: PHDate!) // Converts date-time object to string for firebase storage
                
                databaseRef.child(userUID!).child("PHData").child(dateString).setValue(PHDataArr[index])
                print("Storing PHData: ", PHDataArr[index])
            }
        }
        
    }

    
}


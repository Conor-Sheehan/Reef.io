//
//  FirebaseHandler.swift
//  Reef
//
//  Created by Conor Sheehan on 9/12/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import Firebase

// Firebase Extension for reading
extension AppBrain {
    
    func readGrowData() {
        
        if let firebaseUID = userUID {
            
            databaseRef?.child("Users").child(firebaseUID).child("GrowData").child("CurrentPlantHeight").observeSingleEvent(of: .value){ (snapshot) in
                if let currentPlantHeight = snapshot.value as? Int {
                    self.currentPlantHeight = currentPlantHeight
                }
            }
            
            databaseRef?.child("Users").child(firebaseUID).child("GrowDates").child("SeedlingStartDates").observeSingleEvent(of: .value) { (snapshot) in
                
                // Count the number of seedlings started in Reef
                var growCount = 0
                var seedlingDates: [Date] = []
                
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    // Get seedling start date
                  let seedStartDate = child.key.convertStringToDate()
                    growCount += 1 // Increment grow count
                    seedlingDates.append(seedStartDate)
                }
                
                // Store number of grows with reef
                //self.growsWithReef = growCount
                
                // Store grow date data, if there were dates to read from Firebase
                if !seedlingDates.isEmpty {
                    self.seedlingStartDate = seedlingDates.last
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "growDataRead"), object: nil)
                }
            
              }
                      
        }
    }
    
    func readSensorData() {
        
         if let firebaseUID = userUID {
        
            // READ THE PH DATA FROM FIREBASE
            databaseRef?.child("Users").child(firebaseUID).child("PHData").observeSingleEvent(of: .value) { (snapshot) in
            
                // Store the current PH Value
                var mostRecentPH = "7.5"
            
                // Iterate over all PH Data points stored in Firebbase
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    mostRecentPH = child.value as? String ?? "7.5"
                    print("Current PH", mostRecentPH)
                }
                
                self.currentPH = mostRecentPH
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "phRead"), object: nil)
            }
            
        }
        
    }
    
    
    
    func readWiFiConnected() {
        
        // Check if user has been authorized by firebase
        if let firebaseID = userUID {
            
            // Begin reading path
            databaseRef?.child("Users").child(firebaseID).child("WiFiLastConnected").observe(.value, with: { (snapshot) in
                if let connectionTime = snapshot.value as? String {
                    print("WiFi connected successfully", connectionTime)
                    self.wifiConnected = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
                }
                else { print("WiFi not yet connected") }
            })
        }
    }
    
    
    
}

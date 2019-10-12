//
//  AppBrainCalculations.swift
//  Reef
//
//  Created by Conor Sheehan on 9/12/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
    
    // Date -> String conversion for firebase storage (TAKES DATE RETURNS STRING OF DATE)
    func convertDateToString(date: Date) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    
    // storeDate() takes the String date identifier from Firebase and converts it to a usable Swift Date
    // It stores all of the dates from firebase into the (dateStorage: Date) Array
    func convertStringToDate(str: String) -> Date  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: str)!
    }
    
    func daysSinceDate(date: Date) -> Int {
        return (Calendar.current.dateComponents([.day], from: date, to: Date()).day! + 1)
        
    }
    
    // findGrowStage() computes the growStage based on day counts,
    // plant height, and day hours
    func findGrowStage(){
        let daysSinceSeedStarted: Int = self.daysSinceDate(date: self.seedlingStartDate!)
        
        if(daysSinceSeedStarted <= 16){
            self.growStage = 0
            self.currentDayCountInStage = daysSinceSeedStarted
            self.daysUntilNextStage = 16 - daysSinceSeedStarted
            self.percentStage = Double((16 - self.daysUntilNextStage))/16.0
        }
        else if(daysSinceSeedStarted > 16){
            self.growStage = 1
            self.currentDayCountInStage = daysSinceSeedStarted - 16
            self.daysUntilNextStage = 60 - self.currentDayCountInStage
            self.percentStage = Double((60 - self.daysUntilNextStage))/60.0
        }
        
        // Add functionality to compute when to switch to flowering (if mode is auto-flower)
        // Then check plant height array and look for multiple values of greater than X (say 24" tall)
        // If mode is manual then just check if user set 12 or 18 hours
    }
    
    func parseBluetoothMessage(value: String){
        
        // If app checked in with Reef
        if value.contains("OKC") {
            compiledData = ""
            compiledData += value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                self.storeBasinReadings(basinString: self.compiledData)
            }
            
        }
            
        // If app is receiving pH and plant Height Data
        else if value.contains("OKD1") {
            compiledData = ""
            compiledData += value
            
            print("ADDING TO COMPILED DATA")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("COMPILED DATA", self.compiledData)
                self.storeDataArrays(data: self.compiledData)
            }
            
        }
        // If app is receiving basin refilled data
        else if value.contains("OKB") {
            let responseSplit = value.split(separator: ",")
            let basinNumber = Int(responseSplit[1])!
            
            storeRefilledBasin(basin: basinNumber)
        }
            
        else {
            print("ADDING TO COMPILED DATA IN ELSE LOOP")
            compiledData += value
        }
    }
    
    
    
}

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
        let currentDate = Calendar.current.startOfDay(for: Date())
        let firstDate = Calendar.current.startOfDay(for: date)
        return Calendar.current.dateComponents([.day], from: firstDate, to: currentDate).day!
    }
    
    // findGrowStage() computes the growStage based on day counts,
    // plant height, and day hours
    func findGrowStage() {
        
        let daysSinceSeedStarted: Int = self.daysSinceDate(date: self.seedlingStartDate!)
        
        if daysSinceSeedStarted <= 16 {
            self.growStage = 0
            let daysUntilNextStage = 16 - daysSinceSeedStarted
            self.percentStage = Double((16 - daysUntilNextStage))/16.0
        }
        else if daysSinceSeedStarted > 16 {
            self.growStage = 1
            let daysUntilNextStage = 60 - (daysSinceSeedStarted - 16)
            self.percentStage = Double((60 - daysUntilNextStage))/60.0
        }
        
        // Add functionality to compute when to switch to flowering (if mode is auto-flower)
        // Then check plant height array and look for multiple values of greater than X (say 24" tall)
        // If mode is manual then just check if user set 12 or 18 hours
    }
    
    func parseBluetoothMessage(message: String){
        
        // If app checked in with Reef
        if message.contains("OKC") {
            let BasinString = self.matches(for: "^OKC,[0-9]{1,3},[0-9]{1,3},[0-9]{1,3},$", in: message)
            
            if BasinString.count != 0 {
                
                let basinSubString = message.split(separator: ",")
                basinLevels[0] = Int(basinSubString[1])!
                basinLevels[1] = Int(basinSubString[2])!
                basinLevels[2] = Int(basinSubString[3])!
                
                self.storeBasinLevels(nutrientLevel: basinLevels[0], PHDownLevel: basinLevels[1], PHUpLevel: basinLevels[2])
                
                print("Nutrient lvl:", basinLevels[0], "\nPH Up Lvl:", basinLevels[1], "\nPH Down Lvl:", basinLevels[2])
            }
            
        }
            
        // If app is receiving PH and plant Height Array Data
        else if message.contains("OKD1") {
            compiledData = ""
            compiledData += message
            
            print("ADDING TO COMPILED DATA")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("COMPILED DATA", self.compiledData)
                self.storeDataArrays(data: self.compiledData)
            }
            
        }
        // If app is receiving basin refilled data
        else if message.contains("OKB") {
            
            let responseSplit = message.split(separator: ",")
            let basinNumber = Int(responseSplit[1])!
            
            print("Refilling basin #", basinNumber)
            
            switch basinNumber {
            case 1:
                self.storeBasinLevels(nutrientLevel: 70, PHDownLevel: -1, PHUpLevel: -1)
                basinLevels[0] = 70
            case 2:
                self.storeBasinLevels(nutrientLevel: -1, PHDownLevel: 70, PHUpLevel: -1)
                basinLevels[1] = 70
            case 3:
                self.storeBasinLevels(nutrientLevel: -1, PHDownLevel: -1, PHUpLevel: 70)
                basinLevels[2] = 70
            default:
                print("Entering the default case")
                storeBasinLevels(nutrientLevel: 70, PHDownLevel: 70, PHUpLevel: 70)
                basinLevels[0] = 70; basinLevels[1] = 70; basinLevels[2] = 70;
            }
            
        }
            
        else {
            print("ADDING TO COMPILED DATA")
            compiledData += message
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

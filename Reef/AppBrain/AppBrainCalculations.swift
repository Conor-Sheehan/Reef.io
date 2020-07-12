//
//  AppBrainCalculations.swift
//  Reef
//
//  Created by Conor Sheehan on 9/12/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
    
    
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
    
    
    // findGrowStage() computes the growStage based on day counts,
    // plant height, and day hours
    func findGrowStage() {
        
        let daysSinceSeedStarted: Int = seedlingStartDate?.daysElapsed() ?? 0
        
        if daysSinceSeedStarted <= 16 {
            //self.growStage = 0
            let daysUntilNextStage = 16 - daysSinceSeedStarted
            self.percentStage = Double((16 - daysUntilNextStage))/16.0
        }
        else if daysSinceSeedStarted > 16 {
            //self.growStage = 1
            let daysUntilNextStage = 60 - (daysSinceSeedStarted - 16)
            self.percentStage = Double((60 - daysUntilNextStage))/60.0
        }
        
        // Add functionality to compute when to switch to flowering (if mode is auto-flower)
        // Then check plant height array and look for multiple values of greater than X (say 24" tall)
        // If mode is manual then just check if user set 12 or 18 hours
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

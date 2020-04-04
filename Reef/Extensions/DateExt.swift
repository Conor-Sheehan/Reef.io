//
//  DateExt.swift
//  Reef
//
//  Created by Conor Sheehan on 1/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension Date {
    
    /// Date -> String conversion for firebase storage (TAKES DATE RETURNS STRING OF DATE)
     func convertToString() -> String {

         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en_US")
         formatter.dateFormat = "yyyy-MM-dd HH:mm"
         formatter.amSymbol = "AM"
         formatter.pmSymbol = "PM"
         
         let dateString = formatter.string(from: self)
         return dateString
     }
    
    /// Number of days elapsed since the input Date
    func daysElapsed() -> Int {
         let currentDate = Calendar.current.startOfDay(for: Date())
         let firstDate = Calendar.current.startOfDay(for: self)
         return Calendar.current.dateComponents([.day], from: firstDate, to: currentDate).day!
     }
    
    
    
}

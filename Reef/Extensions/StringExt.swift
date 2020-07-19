//
//  StringExt.swift
//  Reef
//
//  Created by Conor Sheehan on 7/12/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension String {

  // storeDate() takes the String date identifier from Firebase and converts it to a usable Swift Date
  // It stores all of the dates from firebase into the (dateStorage: Date) Array
  func convertStringToDate() -> Date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
      dateFormatter.amSymbol = "AM"
      dateFormatter.pmSymbol = "PM"
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.locale = Locale.current

      return dateFormatter.date(from: self)!
  }

}

//
//  AppBrainCalculations.swift
//  Reef
//
//  Created by Conor Sheehan on 9/12/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
    
    

    
    
    
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

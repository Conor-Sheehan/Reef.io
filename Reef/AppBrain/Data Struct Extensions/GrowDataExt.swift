//
//  GrowDataExt.swift
//  Reef
//
//  Created by Conor Sheehan on 1/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation

extension AppBrain {
    
    
    struct GrowData {
        
        // Date when ecosystem was first established
        var ecosystemStarted: Date?
        
        // Dates when user started a new seed
        var seedStarted: [Date]?
        
        // Dates when user's seedling germinated
        var seedlingGerminated: [Date]?
        
        // Plant Height values
        var plantHeightData: [Float]?
        
        // Current ph Value
        var ph: Float?
        
    }
    
    func storeSeedlingStartDate() {
        
        // Get the current date
        let currentDate = Date()
        
        // Store the Grow start date in firebase
        growDataRef?.child("SeedlingStartDates").child(currentDate.convertToString()).setValue("Started")
        
        // if seed planted array has not been populated, then initialize
//        if growData.seedStartef == nil { growData.seedStarted = [currentDate] }
//        else { growData.seedStarted?.append(currentDate) }
    }
    
    func storeEcosystemStartDate() {
        // Get the current date that ecosystem started
        let currentDate = Date()
        // Store it in firebase
        growDataRef?.child("ecosystemStarted").setValue(currentDate.convertToString())
        // Store it locally
        growData.ecosystemStarted = currentDate
        
    }
    
    
    
    
    
    
}

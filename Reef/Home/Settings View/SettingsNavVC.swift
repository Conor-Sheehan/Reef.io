//
//  SettingsNavVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/18/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import QuickTableViewController

class SettingsNavVC: QuickTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(brain.getSettings().navigatingTo == "GrowMode"){
            self.setGrowModeTable()
        }
        else if(brain.getSettings().navigatingTo == "AquariumLighting"){
            self.setAquariumLightingTable()
        }
        
        else{
            self.setFeederModeTable()
        }

    }
    
    func setGrowModeTable(){
        if(brain.getSettings().growMode == "Auto-Flower"){
            tableContents = [
                RadioSection(title: "Grow Mode", options: [
                    OptionRow(title: "Auto-Flower", isSelected: true, action: { [weak self] _ in
                        brain.setGrowMode(GrowMode: "Auto-Flower") }),
                    OptionRow(title: "Manual", isSelected: false, action: { [weak self] _ in
                        brain.setGrowMode(GrowMode: "Manual") }),
                    ], footer: "See RadioSection for more details."),
            ]
        }
        else{
            tableContents = [
                RadioSection(title: "Grow Mode", options: [
                    OptionRow(title: "Auto-Flower", isSelected: false, action: { [weak self] _ in
                        brain.setGrowMode(GrowMode: "Auto-Flower") }),
                    OptionRow(title: "Manual", isSelected: true, action: { [weak self] _ in
                        brain.setGrowMode(GrowMode: "Manual") }),
                    ], footer: "See RadioSection for more details."),
                
            ]
        }
    }
    
    
    func setFeederModeTable(){
        if(brain.getSettings().feederMode == "Auto-Feed"){
            tableContents = [
                RadioSection(title: "Fish Feeder Mode", options: [
                    OptionRow(title: "Auto-Feed", isSelected: true, action: { [weak self] _ in
                        brain.setFeederMode(FeederMode: "Auto-Feed") }),
                    OptionRow(title: "Manual", isSelected: false, action: { [weak self] _ in
                        brain.setFeederMode(FeederMode: "Manual") }),
                    ], footer: "If you select Manual, you'll receive daily notifications to feed your fish. Auto-Feed will automatically feed your fish twice a day."),
            ]
        }
        else{
            tableContents = [
                RadioSection(title: "Fish Feeder Mode", options: [
                    OptionRow(title: "Auto-Feed", isSelected: false, action: { [weak self] _ in
                        brain.setFeederMode(FeederMode: "Auto-Feed") }),
                    OptionRow(title: "Manual", isSelected: true, action: { [weak self] _ in
                        brain.setFeederMode(FeederMode: "Manual") }),
                    ], footer: "If you select Manual, you'll receive daily notifications to feed your fish. Auto-Feed will automatically feed your fish twice a day."),
            ]
        }
    }
    
    func setAquariumLightingTable(){
        if(brain.getSettings().aquariumLighting == "Ocean"){
            tableContents = [
                RadioSection(title: "Aquarium Lighting", options: [
                    OptionRow(title: "Ocean", isSelected: true, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Ocean") }),
                    OptionRow(title: "Daylight", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Daylight") }),
                    OptionRow(title: "Tropical", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Tropical") }),
                    ], footer: "If you select Manual, you'll receive daily notifications to feed your fish."),
            ]
        }
        else if(brain.getSettings().aquariumLighting == "Daylight"){
            tableContents = [
                RadioSection(title: "Aquarium Lighting", options: [
                    OptionRow(title: "Ocean", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Ocean") }),
                    OptionRow(title: "Daylight", isSelected: true, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Daylight") }),
                    OptionRow(title: "Tropical", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Tropical") }),
                    ], footer: "If you select Manual, you'll receive daily notifications to feed your fish."),
            ]
        }
        else{
            tableContents = [
                RadioSection(title: "Aquarium Lighting", options: [
                    OptionRow(title: "Ocean", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Ocean") }),
                    OptionRow(title: "Daylight", isSelected: false, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Daylight") }),
                    OptionRow(title: "Tropical", isSelected: true, action: { [weak self] _ in
                        brain.setAquariumLighting(AquariumLighting: "Tropical") }),
                    ], footer: "If you select Manual, you'll receive daily notifications to feed your fish."),
            ]
        }
    }
    


}

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
    
    var msgCounter: Int = 1
    
    var brain: AppBrain!
    var appDeleg: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the app delegate to activate instabug and access app delegate data model singleton
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
            brain = appDelegate.appBrain
        }
        
        // User is navigating to grow mode 
        if brain.getSettings().navigatingTo == "GrowMode" {
            self.setGrowModeTable()
        }
        else if brain.getSettings().navigatingTo == "AquariumLighting" {
//            self.setAquariumLightingTable()
        }
        else {
            self.setAquariumStatusTable()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.isNavigationBarHidden = false
     }

    
    /// Sets the settings grow mode table to select auto flower or manual flowering mode
    func setGrowModeTable(){
        var autoFlower = false
        if brain.getSettings().growMode == "Auto-Flower" { autoFlower = true }
        
        tableContents = [
            RadioSection(title: "Grow Mode", options: [
                OptionRow(text: "Auto-Flower", isSelected: autoFlower, action: { [weak self] _ in
                    self?.brain.setGrowMode(GrowMode: "Auto-Flower") }),
                OptionRow(text: "Manual", isSelected: !autoFlower, action: { [weak self] _ in
                    self?.brain.setGrowMode(GrowMode: "Manual") }),
                ], footer: "If you select Auto-Flower, Reef will automatically determine when to flower your grow."),
        ]
    }
    
    func setAquariumStatusTable(){
        
        var status = false
        if brain.getSettings().aquariumStatus == "Full" { status = true }
        
        tableContents = [
            RadioSection(title: "Aquarium Status", options: [
                OptionRow(text: "Full", isSelected: status, action: { [weak self] _ in
                   self?.changeAquariumStatus(status: true)  }),
                OptionRow(text: "Empty", isSelected: !status, action: { [weak self] _ in
                    self?.changeAquariumStatus(status: false)  }),
                ], footer: "If you select empty, your smart aquarium features will turn off."),
        ]
    }
    
    
//    func setAquariumLightingTable(){
//
//        var daylight = false
//        var ocean = false
//        var wavey = false
//
//        if brain.getSettings().aquariumLighting == "Daylight" { daylight = true }
//        else if brain.getSettings().aquariumLighting == "Ocean" { ocean = true }
//        else{ wavey = true }
//
//        tableContents = [
//            RadioSection(title: "Aquarium Lighting", options: [
//                OptionRow(title: "Daylight", isSelected: daylight, action: { [weak self] _ in
//                    self?.changeAquariumLight(lightSetting: 0) }),
//                OptionRow(title: "Ocean", isSelected: ocean, action: { [weak self] _ in
//                    self?.changeAquariumLight(lightSetting: 1) }),
//                OptionRow(title: "Wavey", isSelected: wavey, action: { [weak self] _ in
//                    self?.changeAquariumLight(lightSetting: 2) }), ]),
//        ]
//    }
    
//    func changeAquariumLight(lightSetting: Int) {
//        if appDeleg.connected {
//
//            switch lightSetting {
//                case 0: brain.setAquariumLighting(AquariumLighting: "Daylight")
//                case 1: brain.setAquariumLighting(AquariumLighting: "Ocean")
//                default: brain.setAquariumLighting(AquariumLighting: "Wavey")
//            }
//
//            if msgCounter == 1 {
//                msgCounter += 1
//            }
//            else{
//                print("Light setting", lightSetting)
//                appDeleg.sendMessage(message: "0R" + String(lightSetting))
//                msgCounter = 1
//            }
//
//        }
//        else{
//            self.setAquariumLightingTable()
//            self.alertView(ttle: "Disconnected from Reef", msg: "To update Reef's settings connect to Reef and try again")
//        }
//    }
    
    /// Changes the status of the smart aquarium features (On/Off)
    func changeAquariumStatus(status: Bool) {
        
        status ? brain.storeAquariumStatus(full: 1) : self.brain.storeAquariumStatus(full: 0)
        setAquariumStatusTable()
    }
    
 


}


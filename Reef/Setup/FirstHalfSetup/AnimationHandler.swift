//
//  setupAnimationHandler.swift
//  Reef
//
//  Created by Conor Sheehan on 8/3/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import AudioToolbox

extension InitialSetup {
    
    // Animate the setup introduction
    func displayAquariumSetup(){
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseOut], animations: {
            self.reefImage.alpha = 0.0
            self.bluetoothText.alpha = 0.0
            
        })
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.curveEaseIn], animations: {
            self.plantIcon.alpha = 1.0
            self.Aquarium.alpha = 1.0
            self.headerText.alpha = 1.0
            self.connectButton.setTitle("Continue", for: .normal)
        })
        UIView.animate(withDuration: 0.6, delay: 0.8, options: [.curveEaseIn], animations: {
            self.infoText.alpha = 1.0
        })
        
    }
    
    // Start Filling Tank is the animation for user starting to fill tank
    func startFillingTank(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.infoText.alpha = 0.0
            self.headerText.alpha = 0.0
        })
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseIn], animations: {
             self.headerText.alpha = 1.0
             self.infoText.alpha = 1.0
            self.headerText.text = "Start Filling Tank"
            self.infoText.text = "Once the aquarium light turns on, fill your tank with water until notified by the app."
        })
    }
    
    // finishedFillingTank() controls the animations when the tank is full
    func finishedFillingTank(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.infoText.alpha = 0.0
            self.headerText.alpha = 0.0
        })
        UIView.animate(withDuration: 0.5, delay: 0.25, options: [.curveEaseIn], animations: {
            self.headerText.alpha = 1.0
            self.headerText.text = "Your tank is full!"
            self.infoText.text = "Anytime your aquarium is low, Reef will send you a notification."
            self.water.alpha = 1.0
            self.infoText.alpha = 1.0
            self.connectButton.isEnabled = true
        })

    }
    
    
}

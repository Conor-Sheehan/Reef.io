//
//  BTReceiver.swift
//  Reef
//
//  Created by Conor Sheehan on 7/22/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import Foundation
import CoreBluetooth

extension AppDelegate: CBPeripheralDelegate {
    
    // Discovered bluetooth device services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // Look through the service list
        if let servicePeripheral = peripheral.services! as [CBService]?{
            for service in servicePeripheral{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    // Discovered peripheral characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        // Find characteristics of BLE Device
        for characteristic in service.characteristics! {
            
            if (characteristic.uuid == CBUUID(string: UuidCharacteristic)) {
                
                let thisCharacteristic = characteristic as CBCharacteristic
                
                self.writeCharacteristic = thisCharacteristic
                self.writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
                self.reefBluetooth.setNotifyValue(true, for: thisCharacteristic)
                
                // After connecting and verifying characteristics, then check in Reef
                // If setup is complete, then check in with Reef
                if setupComplete { checkInWithReef() }
            }
        }
    }
    
    // Called when App receives response from Reef
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("\nReceived message: ")
        noResponse = false
        
        if let response = String(data: characteristic.value!, encoding: String.Encoding.utf8) {
            parseBluetoothResponse(responseMsg: response)
            print(response)
        }
        
        else { print("INVALID MESSAGE RECEIVED FROM REEF")}
        
    }
    
    
}


/// EXTENSION FOR BLUETOOTH RECEIVER HELPER FUNCTIONS
extension AppDelegate {
    
    
    /// Gets called when App establishes Connection with Reef Ecosystem
    /// Sends a check-in message if this is the first connection to Reef after the app was loaded
    /// Or if it's been at least 30 minutes since the last check-in
    func checkInWithReef() {
        
        // If app has communicated with Reef since app was loaded
        if let recentCommunication = lastCommunication {
            // Check whether it was longer than 5 minutes ago
            let timeSinceCommunication = Calendar.current.dateComponents([.minute, .second], from: recentCommunication, to: Date())
            
            print("Time since last communication:", timeSinceCommunication.minute!, "minutes", timeSinceCommunication.second!, "seconds")
            
            if timeSinceCommunication.minute! >= 30 {
                print("More than 30 minutes since last communication")
                
                // Update most recent communication time
                lastCommunication = Date()
                stayConnected = true
                
                // Send the message
                sendMessage(message: getCurrentCheckInMessage())
                
                // Store most recent communication in firebase
                appBrain.storeMostRecentCommunicationDate()
            }
            
        }
            // Else this is the first connection since the app has been loaded
        else {
            // Send first communication since app was launched
            print("First communication since app was launched")
            
            // Update most recent communication
            lastCommunication = Date()
            stayConnected = true
            sendMessage(message: getCurrentCheckInMessage())
            
            // Store most recent communication in firebase
            appBrain.storeMostRecentCommunicationDate()
        }
        
    }
    
    
    /// Called when BLE Peripheral receives a valid response from Reef
    func parseBluetoothResponse(responseMsg: String) {
        
        // if app is not in background, then notify VC of new message
        if !appIsInBackground {
            mostRecentMessage = responseMsg
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedNewMessage"), object: nil)
        }
        
        // CHECK-IN RESPONSE
        if responseMsg.contains("OKC") {
            
            // If user has completed setup, then store the data and request sensor data from Reef
            if setupComplete { appBrain.parseBluetoothMessage(message: responseMsg); sendMessage(message: "0D1") }
            // Else, notify the setup VC that we have established a complete connection with Reef
            else { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)  }
        }
            
        // Aquarium Pumps Response
        else if responseMsg.contains("OKA,1") { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pumpsTurnedOn"), object: nil) }
        else if responseMsg.contains("OKB,4") {
            appBrain.parseBluetoothMessage(message: responseMsg)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "allBasinsFilled"), object: nil) }
            
        else if responseMsg.contains("OKD1")    { appBrain.parseBluetoothMessage(message: responseMsg); sendMessage(message: "0D2");  }
        else if responseMsg.contains("OKD2")    { if appIsInBackground { stayConnected = false; disconnectFromReef() } }
        else if responseMsg.contains("OKS")     { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedSunrise"), object: nil) }
        else if responseMsg.contains("OKR")     { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedAqrLight"), object: nil) }
        
        else if responseMsg.contains("OKH")     { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setDayHours"), object: nil) }
        else if responseMsg.contains("OKB")     {
            appBrain.parseBluetoothMessage(message: responseMsg)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refilledBasin"), object: nil)
        }
        else { self.appBrain.parseBluetoothMessage(message: responseMsg) }
        
    }
    
    /// Sends a message to Reef
    func sendMessage(message: String) {
        
        if connected {
            // Package string into Data Object
            if let data = message.data(using: String.Encoding.utf8) {
                self.reefBluetooth.writeValue(data, for: self.writeCharacteristic, type: self.writeType)
                print("Sending message to Reef: " + message)
            }
        }
    }
    
    // Gets most recent message from Reef
    func getMostRecentMessage() -> String { return mostRecentMessage }
    
    /// Sends current military time to Reef
    func getCurrentCheckInMessage() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        
        var message: String = ""
        
        if minutes.count == 1 { message = "0C"+hour+":0"+minutes }
        else { message = "0C"+hour+":"+minutes }
        
        return message
    }
    
    
}


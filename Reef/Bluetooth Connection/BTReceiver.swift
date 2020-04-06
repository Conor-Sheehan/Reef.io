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
        noResponse = false
        
        if let response = String(data: characteristic.value!, encoding: String.Encoding.utf8) {
            print("Received response:", response)
            parseBluetoothResponse(responseMsg: response)
        }
        
        else {
            sendMessage(message: sentMessage)
            print("INVALID MESSAGE RECEIVED FROM REEF")}
        
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
            
        }
        
    }
    
    
    /// Called when BLE Peripheral receives a valid response from Reef
    func parseBluetoothResponse(responseMsg: String) {
        
        
        // if app is not in background, then notify VC of new message
        if !appIsInBackground {
            mostRecentMessage = responseMsg
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedNewMessage"), object: nil)
        }
        
        // If Reef improperly read the command, then RESEND the mssage
        if !responseMsg.contains("K") && responseMsg != sentMessage  {
            print("Resending message:", sentMessage)
            sendMessage(message: sentMessage)
        }
        // Else if Reef read the correct command, then tell Reef to Proceed
        else if !responseMsg.contains("K") && responseMsg == sentMessage  { sendMessage(message: "P") }
        
         //Else we've received confirmation of Reef's update and need to update App UI/database accordingly
        else {
          reefConfirmedResponseHandler(responseMsg: responseMsg)
      }
        
    }
    
    /// Handles the confirmed command responses from Reef, once Reef has properly received command from App
    func reefConfirmedResponseHandler(responseMsg: String) {
        let responses = ["OKC","OKD1", "OKD2", "OKS", "OKR","OKH", "OKA,1", "OKB", "OKB,4"]
        let notificationNames = ["connected","receivedPHData", "receivedPlantHeightData", "updatedSunrise", "updatedAqrLight","setDayHours","pumpsTurnedOn", "refilledBasin","allBasinsFilled"]
        var index = 0
        
        for response in responses {
            // if response from Reef contains the response command
            if responseMsg.contains(response) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationNames[index]), object: nil)
                // If App Received Check in Msg Response from Reef
                if response == responses[0] && setupComplete {// Store most recent communication in firebase
                    appBrain.storeMostRecentCommunicationDate(); appBrain.parseBluetoothMessage(message: responseMsg); sendMessage(message: "0D1") }
                else if response == responses[1] { appBrain.parseBluetoothMessage(message: responseMsg); sendMessage(message: "0D2"); }
                else if response == responses[2] && appIsInBackground { stayConnected = false; disconnectFromReef() }
                else if response == responses[7] || response == responses[8] { appBrain.parseBluetoothMessage(message: responseMsg) }
            }
            
            index += 1
        }
        
    }
    
    /// Sends a message to Reef
    func sendMessage(message: String) {
        
        if connected {
            // store message sent if it is not a proceed command
            if message != "P" { sentMessage = message; print("Sent message is now:", sentMessage) }

            // Package string into Data Object
            if let data = message.data(using: String.Encoding.utf8) {
                self.reefBluetooth.writeValue(data, for: self.writeCharacteristic, type: self.writeType)
                print("Sending message to Reef: " + message + "\n")
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


//
//  BTConnect.swift
//  Reef
//
//  Created by Conor Sheehan on 7/22/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import Foundation
import CoreBluetooth

extension AppDelegate: CBCentralManagerDelegate {
    
    // Called when the connection controller's state is updated (turned on, diabled, etc)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            // Start looking
            scanForReef()
            debugPrint("Searching for Reef...")
            
        } else {
            // Notify user to turn on bluetooth
            instantNotification(notificationTitle: "Bluetooth turned off.", notifcationBody: "Turn on bluetooth to stay connected with Reef.")
        }
        
    }
    
// Called after a bluetooth device is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let deviceName = peripheral.name {
            
            if deviceName == "DSDTECH HM-10" {
                
                print("\nConnecting with Reef")
            
                self.connectionController.stopScan()
                self.reefBluetooth = peripheral
                self.reefBluetooth.delegate = self
                self.connected = true
                
                // Connect to the perhipheral proper
                connectionController.connect(self.reefBluetooth, options: nil )
                
                // If app is in background, then disconnect and reconnect every 7 seconds to keep connection alive
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                    if !self.stayConnected { self.connectionController.cancelPeripheralConnection(self.reefBluetooth) }
                }
            }
        }
        
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Ask for services
        peripheral.discoverServices(nil)
    }

    // Called anytime that the peripheral is disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = false
        print("Disconnecting from Reef")
        scanForReef()
    }
    
    func disconnectFromReef() { self.connectionController.cancelPeripheralConnection(self.reefBluetooth) }
    func scanForReef()        { self.connectionController.scanForPeripherals(withServices: self.serviceUUIDForScanning, options: nil) }
    
    
}

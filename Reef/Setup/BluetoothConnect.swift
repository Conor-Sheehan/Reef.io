//
//  BluetoothConnect.swift
//  Reef
//
//  Created by Conor Sheehan on 8/8/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothConnectDelegate: class {
    func simpleBluetoothIO(BluetoothConnect:BluetoothConnect, didReceiveValue value: Int8)
}

class BluetoothConnect: NSObject {
    
    // Bluetooth variables and constants
    var connectionController: CBCentralManager!
    var reefBluetooth: CBPeripheral!
    var writeType: CBCharacteristicWriteType = .withResponse
    let serviceUUIDForScanning: [CBUUID] = [CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")]
    var writeCharacteristic: CBCharacteristic!
    let UuidCharacteristic = "0000ffe1-0000-1000-8000-00805f9b34fb"
    var keepScanning = true
    var bluetoothCounter: Int = 1
    var connected: Bool = false
    var scanning: Bool = false
    var classCalled: String = ""
    
    
    init(delegate: BluetoothConnectDelegate?){
        super.init()
        
        self.connectionController = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BluetoothConnect: CBCentralManagerDelegate {
    
    // Called when the connection controller's state is updated (turned on, diabled, etc)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            // Start looking
            self.connectionController.scanForPeripherals(withServices: nil, options: nil)
            self.scanning = true
            
            // If we don't connect within 7 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                if(self.connected == false && self.scanning == true){
                    self.connectionController.stopScan()
                    InitialSetup().connectButton.isEnabled = true
                    InitialSetup().displayAlert(title: "Connection Failed.", message: "Make sure your Reef is plugged in and turned on and try again.", actionMsg: "OK")
                }
            }
            debugPrint("Searching ...")
            
        } else {
            
            // Tell User to turn bluetooth on via alert
            InitialSetup().displayAlert(title: "Bluetooth is turned off.", message: "Turn on your bluetooth to connect with Reef", actionMsg: "OK")
        }
        
    }
    
    // Called after a bluetooth device is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Device
        debugPrint("discovered something: \(peripheral.name)")
        
        if(peripheral.name == "ECO-123456"){
            self.connectionController.stopScan()
            self.reefBluetooth = peripheral
            self.reefBluetooth.delegate = self
            self.scanning = false
            
            // Connect to the perhipheral proper
            connectionController.connect(self.reefBluetooth, options: nil )
            
            // If we don't connect within 7 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                if(self.connected == false && self.scanning == false) {
                    self.connectionController.stopScan()
                    self.connectionController.cancelPeripheralConnection(self.reefBluetooth)
                    InitialSetup().connectButton.isEnabled = true
                    InitialSetup().displayAlert(title: "Connection Failed.", message: "Make sure your Reef is plugged in and turned on and try again.", actionMsg: "OK")
                }
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Ask for services
        peripheral.discoverServices(nil)
        
        // Debug
        debugPrint("Getting services ...")
    }
    
}

extension BluetoothConnect: CBPeripheralDelegate {
    // Discovered bluetooth device services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // Look through the service list
        debugPrint("found services")
        
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
            
            if(characteristic.uuid == CBUUID(string: UuidCharacteristic)){
                
                let thisCharacteristic = characteristic as CBCharacteristic
                
                self.writeCharacteristic = thisCharacteristic
                self.writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
                self.reefBluetooth.setNotifyValue(true, for: thisCharacteristic)
                
                // Once Connected grab current time from phone
                let date = Date()
                let calendar = Calendar.current
                let hour = String(calendar.component(.hour, from: date))
                let minutes = String(calendar.component(.minute, from: date))
                
                var message: String = ""
                if(minutes.count == 1){
                    message = "0C"+hour+":0"+minutes
                }
                else{
                    message = "0C"+hour+":"+minutes
                }
                
                
                if let data = message.data(using: String.Encoding.utf8) {
                    self.reefBluetooth.writeValue(data, for: writeCharacteristic, type: writeType)
                    print("sending to Reef: " + message)
                }
                
            }
            
        }
    }
    
    // Called when the we receive response from Reef
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        let str = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
        print(str)
        
        if(str.contains("OKC")){
            self.connected = true
            print("Successfully connected to reef")
            InitialSetup().bluetoothConnected()
        }
        
    }
}

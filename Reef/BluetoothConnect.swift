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
    func bluetoothConnectReceivedMessage(BluetoothConnect:BluetoothConnect, didReceiveValue value: String)
    
    func bluetoothConnectDiscovered(BluetoothConnect:BluetoothConnect, didDiscover peripheral: String)
    
    func bluetoothConnectDisconnected(BluetoothConnect:BluetoothConnect, didDisconnectPeripheral peripheral: Bool)
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
    var scanning: Bool = false
    var classCalled: String = ""
    weak var delegate: BluetoothConnectDelegate?
    var stayDisconnected = false
    var connected: Bool = false
    
    
    init(delegate: BluetoothConnectDelegate?){
        super.init()
        self.stayDisconnected = false
        self.delegate = delegate
        
        print("Bluetooth connected: ", connected)
        
        self.connectionController = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Assigns the delegate to whichever viewController or State (e.g Background) that user is in
    // Allows data to be properly passed from bluetooth into the current view
    func reassignDelegate(delegate: BluetoothConnectDelegate?){
        self.delegate = delegate
    }
    
    func reconnectFromBackground(){
        self.connectionController = CBCentralManager(delegate: self, queue: nil)
    }
    
    func sendMessage(value: String) {
        if(connected){
            print("Sending message", value)
            if let data = value.data(using: String.Encoding.utf8) {
                self.reefBluetooth.writeValue(data, for: writeCharacteristic, type: writeType)
            }
        }
    }
    
    func isConnected() -> Bool {
        return self.connected
    }
}

extension BluetoothConnect: CBCentralManagerDelegate {
    
    // Called when the connection controller's state is updated (turned on, diabled, etc)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            // Start looking
            self.connectionController.scanForPeripherals(withServices: serviceUUIDForScanning, options: nil)
            self.scanning = true
            
            debugPrint("Searching ...")
            
        } else {
            
        }
        
    }
    
    // Called after a bluetooth device is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Device
        debugPrint("discovered something: \(peripheral.name)")
        
        if let deviceName = peripheral.name {
            delegate?.bluetoothConnectDiscovered(BluetoothConnect: self, didDiscover: deviceName)
        
            if(deviceName == "DSDTECH HM-10"){
                self.connectionController.stopScan()
                self.reefBluetooth = peripheral
                self.reefBluetooth.delegate = self
                self.scanning = false
                
                // Connect to the perhipheral proper
                connectionController.connect(self.reefBluetooth, options: nil )
                
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Ask for services
        peripheral.discoverServices(nil)
        
        // Debug
        debugPrint("Getting services ...")
    }
    
    // Called anytime that the peripheral is disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = false
        
        print("Disconnecting")

        self.connectionController = CBCentralManager(delegate: self, queue: nil)
        delegate?.bluetoothConnectDisconnected(BluetoothConnect: self, didDisconnectPeripheral: true)
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
        print("Received message")
        connected = true
        
        if let str = String(data: characteristic.value!, encoding: String.Encoding.utf8) {
            print(str)
            delegate?.bluetoothConnectReceivedMessage(BluetoothConnect: self, didReceiveValue: str)
        }
        
        
    }
    
    
}

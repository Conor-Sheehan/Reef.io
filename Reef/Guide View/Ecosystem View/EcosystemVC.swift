//
//  TrendsVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/17/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Firebase

class EcosystemVC: UIViewController {

    @IBOutlet weak var ecosystemLife: UILabel!
    @IBOutlet weak var currentPlantHeight: UILabel!
    @IBOutlet weak var dispenserPercent: UILabel!
    @IBOutlet weak var feederPercent: UILabel!
    @IBOutlet weak var aquariumPercent: UILabel!
    
    var lowestBasinLevel: Int = 100
    
    var userUID = Auth.auth().currentUser?.uid
    var databaseRef = Database.database().reference()
    
    var brain: AppBrain!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        // Load the app delegate to activate instabug and access app delegate data model singleton
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            brain = appDelegate.appBrain
        }
        
        self.ecosystemLife.text = String(brain.ecosystemLife) + " days"
        self.currentPlantHeight.text = String(brain.currentPlantHeight) + " in."

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.readFromFirebase()
    }
    



}

// Firebase handler Extension
extension EcosystemVC {
    
    func readFromFirebase(){
        databaseRef.child("BasinLevels").child(userUID!).child("Aquarium").observeSingleEvent(of: .value){ (snapshot) in
                if let aquariumLvl = snapshot.value as? Int {
                    var aqrmPercent = Int((Double(aquariumLvl) / 8.0)*100)
                    self.aquariumPercent.text = String(aqrmPercent) + "%"
                    self.brain.aquariumLevel = aqrmPercent
            }
        }
        databaseRef.child("BasinLevels").child(userUID!).child("Feeder").observeSingleEvent(of: .value){ (snapshot) in
                if let feederLvl = snapshot.value as? Int {
                    self.feederPercent.text = String(feederLvl/3) + "%"
                    self.brain.feederLevel = feederLvl/3
            }
        }
        
        databaseRef.child("BasinLevels").child(userUID!).child("PhUp").observeSingleEvent(of: .value){ (snapshot) in
            if let phUpLvl = snapshot.value as? Int {
                self.brain.phUpLevel = phUpLvl
                if(phUpLvl < self.lowestBasinLevel){
                    self.dispenserPercent.text = String(phUpLvl) + "%"
                    self.lowestBasinLevel = phUpLvl
                }
            }
        }
        databaseRef.child("BasinLevels").child(userUID!).child("Nutrient").observeSingleEvent(of: .value){ (snapshot) in
            if let nutrientLvl = snapshot.value as? Int {
                self.brain.nutrientLevel = nutrientLvl
                if(nutrientLvl < self.lowestBasinLevel){
                    self.dispenserPercent.text = String(nutrientLvl) + "%"
                    self.lowestBasinLevel = nutrientLvl
                }
            }
        }
        databaseRef.child("BasinLevels").child(userUID!).child("PhDown").observeSingleEvent(of: .value){ (snapshot) in
            if let phDownLvl = snapshot.value as? Int {
                self.brain.phDownLevel = phDownLvl
                if(phDownLvl < self.lowestBasinLevel){
                    self.dispenserPercent.text = String(phDownLvl) + "%"
                    self.lowestBasinLevel = phDownLvl
                }
            }
        }
        
    }
    
}

extension EcosystemVC: BluetoothConnectDelegate {
    func bluetoothConnectReceivedMessage(BluetoothConnect: BluetoothConnect, didReceiveValue value: String) {
        print("RECEIVED VALUE FROM Ecosystem", value)
    }
    
    func bluetoothConnectDiscovered(BluetoothConnect: BluetoothConnect, didDiscover peripheral: String) {
        print("Found peripheral in Ecosystem")
    }
    
    func bluetoothConnectDisconnected(BluetoothConnect: BluetoothConnect, didDisconnectPeripheral peripheral: Bool) {
        print("Disconnected in Ecosystem")
    }
    
}

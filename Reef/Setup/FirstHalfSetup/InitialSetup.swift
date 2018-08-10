//
//  BluetoothSetupVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/29/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import CoreBluetooth
import AudioToolbox


class InitialSetup: UIViewController  {
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var bluetoothText: UILabel!
    @IBOutlet weak var Aquarium: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var plantIcon: UIImageView!
    @IBOutlet weak var reefImage: UIImageView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var water: UIImageView!
    
    
    var bluetoothConnect: BluetoothConnect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        bluetoothText.alpha = 1.0
        reefImage.alpha = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Action triggered when user taps the connect button
    @IBAction func Connect(_ sender: UIButton) {
        
        if(self.connectButton.title(for: .normal) == "Connect"){
            self.bluetoothConnected()
           // bluetoothConnect = BluetoothConnect(delegate: self)
            //connectButton.isEnabled = false

//            UIView.animate(withDuration: 0.75, delay: 0.0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
//                self.bluetoothIcon.alpha = 1.0
//            })
        }
            
        else if(self.headerText.text == "Your tank is full!"){
            var storyboard = UIStoryboard(name: "SecondHalfSetup", bundle: nil)
            var controller = storyboard.instantiateViewController(withIdentifier: "FishAndAquascaping") as! FishAndAquascaping
            self.present(controller, animated: true, completion: nil)
        }
            
        // Case when user is filling their tank
        else{
            print("Continue")
           
            self.connectButton.isEnabled = false
            self.startFillingTank()
            
            // Use a timer to call 0KC every 5 seconds and update water level
            
            // For UX Testing Purposes pretend tank was filled
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.finishedFillingTank()
            }
        }

    }
    
    func bluetoothConnected(){
        
            self.displayAlert(title: "Connected to Reef!", message: "Tap continue to be guided through setting up your ecosystem.", actionMsg: "Continue")

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.connectButton.isEnabled = true
        
        // Hide old features and display aquarium setup info
        
    }
    

    
    
    func displayAlert(title: String, message: String, actionMsg: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let actionButton = UIAlertAction(title: actionMsg, style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            
            if(actionMsg == "Continue"){
                  self.displayAquariumSetup()

            }
            
        })
        alert.addAction(actionButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
    
    extension InitialSetup: BluetoothConnectDelegate {
        func simpleBluetoothIO(BluetoothConnect:BluetoothConnect, didReceiveValue value: Int8) {
            
        }
    }



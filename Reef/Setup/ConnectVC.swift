//
//  ConnectVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/7/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import AudioToolbox

class ConnectVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var reefImage: UIImageView!
    
    var connectSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide activity indicator when view first loads
        activityIndicator.alpha = 0.0
        
        // Notify VC when
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectedToReef), name: NSNotification.Name(rawValue: "connected"), object: nil)
        
        // Set setup location identifier to 1
        //UserDefaults.standard.set(1, forKey: "setupLocation")
    }
    

    @IBAction func startConnectionProtocol(_ sender: UIButton) {
        
        // Start animating activity indicator
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
        
        // Disable connect button
        connectButton.isEnabled = false
        connectButton.alpha = 0.5
        connectButton.setTitle("", for: .normal)
        
        // Start Bluetooth Connection Protocol
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate { appDelegate.startBluetoothConnection() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.sendMessage(message: appDelegate.getCurrentCheckInMessage()) }
        }
        
        /// IMPLEMENT CONNECTION TIMEOUT PROTOCOL ///
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {

            // if we have not received a connected to Reef notification, then time out and try again
            if !self.connectSuccess {
                /// SEND ALERT VC about connection timeout ///
                self.alertUser(title: "Connection Failed", message: "Make sure Reef is turned on and your bluetooth is enabled then try again.")
                
                // Reset connection button
                self.connectButton.isEnabled = true
                self.connectButton.alpha = 1.0
                self.connectButton.setTitle("Try again", for: .normal)
                
                // Stop animation and hide activity indicator
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0.0
            }
        }
        
        
    }
    
    /// Called once user successfully connects to Reef's Bluetooth
    @objc func connectedToReef() {
        
        // Set connection success to true
        connectSuccess = true
        
        // Stop animation and hide activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0.0
        
        // Signal success
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.connectButton.alpha = 1.0
        reefImage.alpha = 1.0
        self.connectButton.setTitle("Connected", for: .normal)
        
        // Segue to login sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.performSegue(withIdentifier: "segueToLogin", sender: self)
        }
    }
    
    /// Alert user if their sign up attempt was valid or invalid
    func alertUser(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in })
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    

}

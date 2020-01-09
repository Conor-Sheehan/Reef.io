//
//  ConnectVC.swift
//  Reef
//
//  Created by Conor Sheehan on 1/7/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class ConnectVC: UIViewController {
    
    @IBOutlet weak var wifiImage: UIImageView!
    @IBOutlet weak var connectTitle: UILabel!
    @IBOutlet weak var connectDescription: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var brain: AppBrain!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set setup location identifier to 1
        UserDefaults.standard.set(1, forKey: "setupLocation")
        
        // Retrieve and storee appbrain locally
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            brain = appDelegate.appBrain
        }
        
        // Add observers to notify VC when Wi-Fi is successfully connected
        NotificationCenter.default.addObserver(self, selector: #selector(connectionTest), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectionTest), name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animate Wi-Fi image to convey connection process UX
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.wifiImage.alpha = 0.3
           }, completion: nil)
    }
    
    
    /// Checks if Reef's Wi-Fi has been successfully conneected to the user's database
    @objc func connectionTest() {
        
        // Check if Reef successfully connected to User's Wi-Fi
        if brain.getWifiConnected() { print("Wifi Connected ConnectVC")
            
            // Update UI elements to notify user
            connectTitle.text = "Connected!"
            connectDescription.text = "Reef is now connected to Wi-Fi. Tap below to continue"
            
            // Remove animation from wifi Image
            wifiImage.layer.removeAllAnimations()
            wifiImage.alpha = 1.0
            
            // Allow user to continue by enabling button
            connectButton.isEnabled = true
            connectButton.setTitle("Continue", for: .normal)
        }
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        
        NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "wifiConnected"))
       // Segue to setup
        self.performSegue(withIdentifier: "segueToSetup", sender: self)
    }
    
    


}

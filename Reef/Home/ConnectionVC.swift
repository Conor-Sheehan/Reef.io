//
//  ConnectionVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/18/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit

class ConnectionVC: UIViewController {
    
    // UI ELEMENTS
    @IBOutlet weak var bluetoothIndicator: UIImageView!
    @IBOutlet weak var connectionText: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var reefImage: UIImageView!
    
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
        
        displayReefConnectionState()
        
        // Set notifiers for when Reef's Bluetooth Connection State Changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayReefConnectionState), name: NSNotification.Name(rawValue: "connectionStateChange"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.isNavigationBarHidden = false
      }

      override func viewWillDisappear(_ animated: Bool) {
          self.navigationController?.isNavigationBarHidden = true
      }
    
    @objc func displayReefConnectionState() {
        // If Reef is connected, then set indicators to ON
        if appDeleg.connected {
            bluetoothIndicator.image = #imageLiteral(resourceName: "Bluetooth State")
            connectionText.text = "Connected"
            checkInButton.alpha = 1.0
            checkInButton.isEnabled = true
            reefImage.alpha = 1.0
        }
        // Else set to OFF
        else {
            bluetoothIndicator.image = #imageLiteral(resourceName: "Disconnected")
            connectionText.text = "Disconnected"
            checkInButton.alpha = 0.5
            checkInButton.isEnabled = false
            reefImage.alpha = 0.5
        }
        
    }
    



}

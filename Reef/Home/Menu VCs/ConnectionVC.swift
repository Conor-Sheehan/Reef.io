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
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var reefImage: UIImageView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var reefName: UILabel!
    @IBOutlet weak var ecosystemProgressBar: UIProgressView!
    @IBOutlet weak var ecosystemPercent: UILabel!
    @IBOutlet weak var reefGrows: UILabel!
    
    
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
        
        displayReefConnectionState()
        displayEcosystemProgress()
        displayGrowsWithReef()
        displayUsersName()
        
        // Set notifiers for when Reef's Bluetooth Connection State Changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayReefConnectionState), name: NSNotification.Name(rawValue: "connectionStateChange"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.isNavigationBarHidden = false
      }

      override func viewWillDisappear(_ animated: Bool) {
          self.navigationController?.isNavigationBarHidden = true
      }
    
    func displayUsersName() {
        reefName.text = appDeleg.appBrain.getSettings().firstName + "'s Reef"
    }
    
    @objc func displayReefConnectionState() {
        // If Reef is connected, then set indicators to ON
        if appDeleg.connected {
            connectionStatus.text = "Connected"
        }
        // Else set to OFF
        else {
            connectionStatus.text = "Searching.."
        }
    }
    
    func displayEcosystemProgress() {
        let ecoProgress = appDeleg.appBrain.getEcosystemProgress()
        ecosystemProgressBar.progress = ecoProgress
        ecosystemPercent.text = String(Int(ecoProgress*100)) + "%"
    }
    
    func displayGrowsWithReef() {
        let growsWithReef = appDeleg.appBrain.getGrowData().growsWithReef
        reefGrows.text = String(growsWithReef)
    }
    
    @IBAction func checkIn(_ sender: UIButton) {
        appDeleg.sendMessage(message: appDeleg.getCurrentCheckInMessage())
    }
    


}

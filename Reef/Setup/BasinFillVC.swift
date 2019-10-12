//
//  BasinFillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/8/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import AudioToolbox

class BasinFillVC: UIViewController {
    
    @IBOutlet weak var basinImage: UIImageView!
    @IBOutlet weak var filledButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
     var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set notifier to respond once Reef marks all basins full
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResponse), name: NSNotification.Name(rawValue: "allBasinsFilled"), object: nil)
        
        basinImage.alpha = 0.5
        activityIndicator.alpha = 0.0
        
        // Set setup location identifier to 4
        // UserDefaults.standard.set(4, forKey: "setupLocation")
    }
    
    @IBAction func filledBasins(_ sender: UIButton) {
        // Send all basins refilled message
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate { appDelegate.sendMessage(message: "0B4") }
        // NOTE: ADD TIMEOUT TO ENSURE THAT COMMAND WAS SUCCESSFULLY SENT AND RECEIVED //
        
        filledButton.alpha = 0.5
        filledButton.isEnabled = false
        filledButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if !self.received {
                self.filledButton.alpha = 1.0
                self.filledButton.isEnabled = true
                self.filledButton.setTitle("Try again", for: .normal)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0.0
            }
        }
        
    }
    
    /// Called by notification center once Reef responds that basins were marked full
    @objc func receivedResponse() {
        // Alert user of successful communication
        print("Basins successfully refilled!")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        received = true
        
        filledButton.alpha = 1.0
        basinImage.alpha = 1.0
        filledButton.setTitle("Filled!", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0.0
        
        // Perform Segue to Basin Refill VC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            // Perform Segue to Next Steps VC
            self.performSegue(withIdentifier: "segueToInfo", sender: self)
        }
    }
    

}

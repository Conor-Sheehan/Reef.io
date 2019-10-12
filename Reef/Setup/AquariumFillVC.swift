//
//  AquariumFillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/8/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import AudioToolbox

class AquariumFillVC: UIViewController {

    @IBOutlet weak var aquariumImage: UIImageView!
    @IBOutlet weak var filledButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set notifier to respond once Reef turns on the aquarium pumps
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResponse), name: NSNotification.Name(rawValue: "pumpsTurnedOn"), object: nil)
        
        aquariumImage.alpha = 0.5
        activityIndicator.alpha = 0.0
        
        // Set setup location identifier to 3
        // UserDefaults.standard.set(3, forKey: "setupLocation")
        
        // FOR FUTURE DEVELOPMENT //
        // Animate aquarium to fill and empty for more enjoyable UX
    }
    
    /// Called once user confirms that they filled their aquarium with water
    @IBAction func filledAquarium(_ sender: UIButton) {
        // Send bluetooth message to Reef to turn on pumps
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate { appDelegate.sendMessage(message: "0A1") }
        
        // Display connection progress
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
    
    /// Called by notification center once Reef responds that Pumps were turned on
    @objc func receivedResponse() {
        
        received = true
        // Alert user of successful communication
        print("PUMPS TURNED ON SUCCESSFULLY")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        filledButton.alpha = 1.0
        aquariumImage.alpha = 1.0
        filledButton.setTitle("Filled!", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0.0
        
        // Perform Segue to Basin Refill VC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.performSegue(withIdentifier: "segueToBasin", sender: self)
        }
    }
    
}

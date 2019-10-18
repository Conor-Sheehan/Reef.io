//
//  SunriseVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/9/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import AudioToolbox

class SunriseVC: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.alpha = 0.0
        
        // Set notifier to respond once Reef marks all basins full
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResponse), name: NSNotification.Name(rawValue: "updatedSunrise"), object: nil)
        
        // Set setup location identifier to 5
        UserDefaults.standard.set(5, forKey: "setupLocation")
    }
    
    @IBAction func setTime(_ sender: UIButton) {
        // NOTE: ADD TIMEOUT TO ENSURE THAT COMMAND WAS SUCCESSFULLY SENT AND RECEIVED //
        
        setButton.alpha = 0.5
        setButton.isEnabled = false
        setButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
        
       let sunriseHour = getSunriseHour()
        print("Sunrise Hour", sunriseHour)
        
        // Send all basins refilled message
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate { appDelegate.sendMessage(message: "0S" + String(sunriseHour)) }
        
        timeoutConnection()
    }
    
    func timeoutConnection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            if !self.received {
                self.setButton.alpha = 1.0
                self.setButton.isEnabled = true
                self.setButton.setTitle("Try again", for: .normal)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0.0
            }
        }
    }
    
    @objc func receivedResponse() {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        received = true
        
        setButton.alpha = 1.0
        setButton.setTitle("Sunrise Set!", for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0.0
        
        // Perform Segue to InfoVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            // Perform Segue to Next Steps VC
            self.performSegue(withIdentifier: "segueToInfo", sender: self)
        }
    }
    
    func getSunriseHour() -> Int {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let formattedTime = timeFormatter.string(from: timePicker.date)
        let sunriseHourComponent = Calendar.current.dateComponents([.hour], from: timePicker.date)
        let sunriseHour = sunriseHourComponent.hour!
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appBrain.setSunriseTime(SunriseTime: formattedTime)
        }
        
        return sunriseHour
    }
    
    
    

}

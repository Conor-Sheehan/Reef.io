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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /// ACTION when user wants to set the sunrise time for their Reef Ecosystem
    @IBAction func setTime(_ sender: UIButton) {
        
        // Retrieve sunrise time that user selected
        let sunriseTime = getSunriseTime()
        print("Sunrise Hour", sunriseTime)
        
        // Store it in Firebase
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appBrain.setSunriseTime(SunriseTime: sunriseTime)
        }
        
        // segue to Info Slide Through
        self.performSegue(withIdentifier: "segueToInfo", sender: self)
    }
    
    
    /// Returns the selected time that the user chose for sunrise
    func getSunriseTime() -> String {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: timePicker.date)
        
        return formattedTime
    }
    
    
    

}

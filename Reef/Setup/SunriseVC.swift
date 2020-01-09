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
    
    var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func setTime(_ sender: UIButton) {
        // NOTE: ADD TIMEOUT TO ENSURE THAT COMMAND WAS SUCCESSFULLY SENT AND RECEIVED //
        
        
        let sunriseTime = getSunriseTime()
        print("Sunrise Hour", sunriseTime)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appBrain.setSunriseTime(SunriseTime: sunriseTime)
        }
    }
    
    
    func getSunriseTime() -> String {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: timePicker.date)
        
        return formattedTime
    }
    
    
    

}

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
    
     var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func filledBasins(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            // Set basin levels to full to turn on pumps
            appDelegate.appBrain.storeBasinLevels(nutrientLevel: 70, PHDownLevel: 70, PHUpLevel: 70)
        }
        
        self.performSegue(withIdentifier: "segueToSunrise", sender: self)
    }
    
    
    
    

}

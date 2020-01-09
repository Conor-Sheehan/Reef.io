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
    
    var received = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FOR FUTURE DEVELOPMENT //
        // Animate aquarium to fill and empty for more enjoyable UX
    }
    
    /// Called once user confirms that they filled their aquarium with water
    @IBAction func filledAquarium(_ sender: UIButton) {
         if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            // Set aquarium to full to turn on pumps
            appDelegate.appBrain.storeAquariumStatus(full: 1)
            
            // Store start date of the aquarium
            appDelegate.appBrain.storeEcosystemStartDate()
        }
        
        self.performSegue(withIdentifier: "segueToBasin", sender: self)

        
    }
    
}

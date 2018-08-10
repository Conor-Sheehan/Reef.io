//
//  FeederAndBasin.swift
//  Reef
//
//  Created by Conor Sheehan on 8/9/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import UIKit

class FeederAndBasin: UIViewController  {
    @IBOutlet weak var HeadlineText: UILabel!
    @IBOutlet weak var FilledButton: UIButton!
    @IBOutlet weak var InfoText: UILabel!
    @IBOutlet weak var FishFeederImage: UIImageView!
    @IBOutlet weak var SolutionDispenserImage: UIImageView!
    

    var viewTracker: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        
        self.FilledButton.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                self.InfoText.alpha = 0.5
            })
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
            self.InfoText.text = "Fill the fish feeder located above the aquarium and then tap \"filled\""
                self.InfoText.alpha = 1.0
            })
            self.FilledButton.isEnabled = true
        }
    }

    @IBAction func filledTapped(_ sender: UIButton) {
        if(HeadlineText.text == "Fish Feeder"){
            self.alertUser(title: "Fish Feeder", message: "Did you fill your fish feeder?")
        }
        else{
            self.alertUser(title: "Solution Dispenser", message: "Did you fill your dispenser cartridges?")
        }
    }
    
    // Alerts user to ask whether or not they filled the basin
    func alertUser(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) -> Void in
        })
        let Yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            if(self.HeadlineText.text == "Fish Feeder"){
                self.showSolutionDispenser()
            }
                // Segues to the planting view controller
            else{
                let PlantingVC = self.storyboard?.instantiateViewController(withIdentifier: "Planting") as! Planting
                PlantingVC.isHeroEnabled = true
                PlantingVC.heroModalAnimationType = .push(direction: .left)
                self.hero_replaceViewController(with: PlantingVC)
                
            }
        })
        alertVC.addAction(action)
        alertVC.addAction(Yes)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // This function animates the Initial Solution Dispenser View
    func showSolutionDispenser(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            self.InfoText.alpha = 0.5
            self.FishFeederImage.alpha = 0.0
            self.HeadlineText.alpha = 0.5
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
            self.HeadlineText.text = "Solution Dispenser"
            self.InfoText.text = "Reef's Solution Dispenser purifies the water and adds nutrients for your plants to thrive."
            self.InfoText.alpha = 1.0
            self.SolutionDispenserImage.alpha = 1.0
            self.HeadlineText.alpha = 1.0
        })
        self.FilledButton.isEnabled = false
        self.fillSolutionDispenser()
    }
    
    // This function animates the Fill Solution Dispenser View
    func fillSolutionDispenser(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut],     animations: {
                self.InfoText.alpha = 0.5
            })
        
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                self.InfoText.alpha = 1.0
                self.InfoText.text = "Fill each cartridge of the Dispenser located on the back of Reef and then tap \"filled\" "
            })
            
            self.FilledButton.isEnabled = true
            
        }
    }

}

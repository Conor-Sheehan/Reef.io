//
//  StartGrowVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/16/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import SafariServices

class StartGrowVC: UIViewController, SFSafariViewControllerDelegate {
    
    // UI ELEMENTS
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    
    var nextTapped = false
    var responseReceived = false
    
    var appDeleg: AppDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the app delegate to access brain and bluetooth protocol
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    /// Segues user to SAFARI VC to show seed planting walkthrough
    @IBAction func learnMoreTapped(_ sender: UIButton) {
        // TO DO: FILM REEF VIDEO ABOUT PLANTING SEEDS FOR REEF //
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.youtube.com/watch?v=PmyGBrKvzbs")! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        
        if !nextTapped {
            nextTapped = true
            learnMoreButton.alpha = 0.0
            // Update UI To second screen
            descriptionText.text = "Once your seedling has sprouted, plant it in Reef's basin and then tap the button below."
            mainButton.setTitle("Seedling Sprouted", for: .normal)
        }
        
        else {
            
            // Set grow started to true
            appDeleg.appBrain.setGrowStartedState(GrowStarted: true)
            
            // Set day hours to 18 in Firebase

            // Dismiss view controller from stack
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    

    

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

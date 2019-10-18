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
        
        // Notifier for receiving bluetooth response from Reef after setting day hours
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedResponse), name: NSNotification.Name(rawValue: "setDayHours"), object: nil)
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
            
            // Send bluetooth mmessage to Reef 0H18 to update day hours
            appDeleg.sendMessage(message: "0H18")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // if Reef has not reesponded then
                if !self.responseReceived {
                    // Alert user that Reef did not receive message
                    self.displayAlert(title: "Try Again.", message: "No response from Reef. Make sure you're connected and try again.")
                }
            }
        }
        
    }
    
    /// Called by notifier once App receives the response from Reef
    @objc func receivedResponse() {
        responseReceived = true
        // Set grow started to true
        appDeleg.appBrain.setGrowStartedState(GrowStarted: true)
        self.navigationController?.popViewController(animated: true)
    }
    

    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

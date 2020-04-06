//
//  DispenserRefillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/31/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Foundation

class BasinVC: UIViewController {

  var basin: Int = -1 // Basin is the tracker for the basin view

  let basinImages =    [#imageLiteral(resourceName: "Nutrients Basin Image"),#imageLiteral(resourceName: "pH Down Basin Image"),#imageLiteral(resourceName: "pH Up Basin")]
  let basinNames = ["Nutrients", "PH Down", "PH Up"]
    
    // UI ELEMENTS
  @IBOutlet weak var nutrientButton: UIButton!
  @IBOutlet weak var phDownButton: UIButton!
  @IBOutlet weak var phUpButton: UIButton!
  @IBOutlet weak var basinImage: UIImageView!
  @IBOutlet weak var nutrientsProgress: UIProgressView!
  @IBOutlet weak var nutrientsPercent: UILabel!
  @IBOutlet weak var nutrientsTitle: UILabel!
  @IBOutlet weak var phDownProgress: UIProgressView!
  @IBOutlet weak var phDownPercent: UILabel!
  @IBOutlet weak var phDownTitle: UILabel!
  @IBOutlet weak var phUpProgress: UIProgressView!
  @IBOutlet weak var phUpPercent: UILabel!
  @IBOutlet weak var phUpTitle: UILabel!
    
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load app brain from App Delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
        
        // Set notifiers for basin data being read and basins refilled
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayBasinLevels), name: NSNotification.Name(rawValue: "basinsRead"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refilledBasin), name: NSNotification.Name(rawValue: "refilledBasin"), object: nil)
      
        // Set Default button borders
      for button in [nutrientButton, phDownButton, phUpButton] {
        button?.layer.borderWidth = 1
        button?.layer.cornerRadius = 5
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor.gray.cgColor
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        displayBasinLevels()
    }
    
    @objc func displayBasinLevels() {
        // Basin levels stored in brain
        let basinLevels = [appDeleg.appBrain.getBasinLevels().nutrientLvl, appDeleg.appBrain.getBasinLevels().phDownLvl, appDeleg.appBrain.getBasinLevels().phUpLvl]
        let basinProgressBars = [nutrientsProgress,phDownProgress,phUpProgress]
        let basinPercents = [nutrientsPercent,phDownPercent,phUpPercent]

        // Iterate over basin levels and convert into percent text and progress bars
        for basin in 0...2 {
            let basinLvl = basinLevels[basin]
            basinProgressBars[basin]?.progress = (Float(basinLvl)/70.0)
            basinPercents[basin]?.text = String(Int((Double(basinLvl)/70.0)*100.0)) + "%"
        }
    }
    
    @IBAction func selectBasin(_ sender: UIButton) {
      let basinTitles = [nutrientsTitle, phDownTitle, phUpTitle]
      let buttons = [nutrientButton, phDownButton, phUpButton]
      basin = sender.tag
      basinImage.image = basinImages[basin]
      
      // Reset fonts of basin titles
      for (index, basinTitle) in basinTitles.enumerated() {
        basinTitle?.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        buttons[index]?.layer.borderWidth = 1
        buttons[index]?.layer.borderColor = UIColor.gray.cgColor
      }
      // Bold selected title
      basinTitles[basin]?.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
      buttons[basin]?.layer.borderWidth = 2
      buttons[basin]?.layer.borderColor = UIColor.black.cgColor
    }
    

    
    /// ACTION WHEN USER TAPS ON REFILLING CARTRIDGE
    @IBAction func refillCartridge(_ sender: UIButton) {
      if basin != -1 {
        refillBasinAlert(title: "Refill Basin", message: "Did you refill Reef's " + basinNames[basin] + " basin?")
      }
      else {
        displayAlert(title: "Select Basin", message: "Select a basin to refill from the list")
      }
    }

    // If Basin was refilled, then update the UI to match
    @objc func refilledBasin() {
        displayBasinLevels()
        displayAlert(title: "Refilled Basin!", message: "Alerted Reef that you refilled the " + basinNames[basin] + " basin.")
    }
    
    
    func refillBasinAlert(title: String, message: String){
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            
            // if App is Connected to Reef's bluetooth, then send a refill mnessage
            if self.appDeleg.connected {
                let message = "0B" + String(self.basin+1)
                self.appDeleg.sendMessage(message: message)
            }
            else {
                self.displayAlert(title: "Disconnected from Reef", message: "Connect to Reef and try again")
            }
        })

        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in })
        alertController.addAction(yes)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


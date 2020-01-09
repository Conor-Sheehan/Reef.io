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

    var basin: Int = 0 // Basin is the tracker for the basin view

    let basinImages =    [#imageLiteral(resourceName: "Nutrients Basin Image"),#imageLiteral(resourceName: "PH Down Basin Image"),#imageLiteral(resourceName: "PH Up Basin")]
    let basinNames = ["Nutrients", "PH Down", "PH Up"]
    
    // UI ELEMENTS
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
        basin = sender.tag
        basinImage.image = basinImages[basin]
        
        // Reset fonts of basin titles
        for basinTitle in basinTitles {
            basinTitle?.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        }
        // Bold selected title
        basinTitles[basin]?.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
    }
    

    
    /// ACTION WHEN USER TAPS ON REFILLING CARTRIDGE
    @IBAction func refillCartridge(_ sender: UIButton) {
        refillBasinAlert(title: "Refill Basin", message: "Did you refill Reef's " + basinNames[basin] + " basin?")
    }

    // If Basin was refilled, then update the UI to match
    @objc func refilledBasin() {
        displayBasinLevels()
        displayAlert(title: "Refilled Basin!", message: "Alerted Reef that you refilled the " + basinNames[basin] + " basin.")
    }
    
    
    func refillBasinAlert(title: String, message: String){
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            
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


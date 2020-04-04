//
//  SettingsVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/17/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import QuickTableViewController


class SettingsVC:  QuickTableViewController {
   
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var pickerBackground: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    var brain: AppBrain!
    var appDeleg: AppDelegate!
    
    var growStartedText = "Start Grow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.bringSubviewToFront(self.pickerBackground)
        self.view.bringSubviewToFront(self.timePicker)
        self.view.bringSubviewToFront(self.doneButton)
        
        self.timePicker.alpha = 0.0
        self.pickerBackground.alpha = 0.0
        self.doneButton.alpha = 0.0
    
        
        // Load the app delegate to activate instabug and access app delegate data model singleton
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
            brain = appDelegate.appBrain
        }
        
       
        
        if brain.reefSettings.activeGrow() { growStartedText = "End Grow"}
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatedSunrise), name: NSNotification.Name(rawValue: "updatedSunrise"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    /// Sets the contents in the settings table anytime data is updated
    func setTableContents() {
        
        tableContents = [
            Section(title: "Grow Settings", rows: [
                NavigationRow(text: "Grow Mode", detailText: .value1(brain.getSettings().growMode), icon: .none, action: { [weak self] in self?.navigateToGrowMode($0)}),
                NavigationRow(text: "Sunrise Time", detailText: .value1(brain.getSettings().sunriseTime), icon: .none, action: { [weak self] in self?.showTimePicker($0) }),
                NavigationRow(text: "Day Length", detailText: .value1("18 Hours"), icon: nil)
                ]),
            
            Section(title: "Aquarium Settings", rows: [
                NavigationRow(title: "Aquarium Full", subtitle: .rightAligned(brain.reefSettings.aquariumFull), icon: nil, action: { [weak self] in self?.navigateToAquariumStatus($0) }),
                ]),
            
            Section(title: "App Settings", rows: [
                SwitchRow(title: "Notifications", switchValue: true, action: { _ in }),
                ], footer: "Reef will send you notifications about the progress of your grow and when you need to interact with the ecosystem."),
            
            Section(title: "Grow State", rows: [
                TapActionRow(title: growStartedText, action: { [weak self] in self?.startEndGrow($0) })
                ]),
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTableContents()
    }


    private func startEndGrow(_ sender: Row) {
       print("Start Grow")
        if brain.reefSettings.activeGrow() {
            brain.setGrowStage(stage: .inactive)
        }
        else { brain.setGrowStage(stage: .seedling) }
        
        self.setTableContents()
    }
    
    private func navigateToGrowMode(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "GrowMode")
        self.performSegue(withIdentifier: "SettingsNavVC", sender: self)
    }
    
    private func navigateToAquariumLighting(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "AquariumLighting")
        self.performSegue(withIdentifier: "SettingsNavVC", sender: self)
    }
    
    private func navigateToAquariumStatus(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "AquariumStatus")
        self.performSegue(withIdentifier: "SettingsNavVC", sender: self)
    }
    
    private func showTimePicker(_ sender: Row) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            self.timePicker.alpha = 1.0
            self.pickerBackground.alpha = 1.0
            self.doneButton.alpha = 1.0
        })
    }
    
    @IBAction func chooseTime(_ sender: UIButton) {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let formattedTime = timeFormatter.string(from: timePicker.date)
        
        // if user is connected with Reef, then store updated time
        brain.setSunrise(time: formattedTime)
        self.setTableContents()

        
        // Animate Hiding the Time Picker
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            self.timePicker.alpha = 0.0
            self.pickerBackground.alpha = 0.0
            self.doneButton.alpha = 0.0
        })
    }
    
    @objc func updatedSunrise() { alertView(ttle: "Updated!", msg: "Reef's sunrise time was successfully updated.") }
    
    func alertView(ttle: String, msg: String){
        
        let alert = UIAlertController(title: ttle, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


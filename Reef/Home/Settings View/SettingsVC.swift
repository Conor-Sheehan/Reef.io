//
//  SettingsVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/17/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import QuickTableViewController

var brain = AppBrain()

class SettingsVC:  QuickTableViewController {
   
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var pickerBackground: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: self.pickerBackground)
        self.view.bringSubview(toFront: self.timePicker)
        self.view.bringSubview(toFront: self.doneButton)
        
        self.timePicker.alpha = 0.0
        self.pickerBackground.alpha = 0.0
        self.doneButton.alpha = 0.0

    }
    
    func setTableContents(){
        tableContents = [
            
            Section(title: "Grow Settings", rows: [
                NavigationRow(title: "Grow Mode", subtitle: .rightAligned(brain.getSettings().growMode), icon: nil, action: { [weak self] in self?.navigateToGrowMode($0)}),
                NavigationRow(title: "Sunrise Time", subtitle: .rightAligned(brain.getSettings().sunriseTime), icon: nil, action: { [weak self] in self?.showTimePicker($0) }),
                NavigationRow(title: "Day Length", subtitle: .rightAligned("18 Hours"), icon: nil)
                ]),
            
            Section(title: "Aquarium Settings", rows: [
                NavigationRow(title: "Aquarium LED", subtitle: .rightAligned(brain.getSettings().aquariumLighting), icon: nil, action: { [weak self] in self?.navigateToAquariumLighting($0) }),
                NavigationRow(title: "Fish Feeder Mode", subtitle: .rightAligned(brain.getSettings().feederMode), icon: nil, action: { [weak self] in self?.navigateToFeederMode($0) }),
                ]),
            
            Section(title: "App Settings", rows: [
                SwitchRow(title: "Notifications", switchValue: true, action: { _ in }),
                ], footer: "Reef will send you notifications about the progress of your grow and when you need to interact with the ecosystem."),
            
            Section(title: "Start Grow", rows: [
                TapActionRow(title: "Start Grow", action: { [weak self] in self?.showAlert($0) })
                ]),
            
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear")
        self.setTableContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func showAlert(_ sender: Row) {
        // ...
    }
    
    private func navigateToGrowMode(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "GrowMode")
        self.performSegue(withIdentifier: "SettingsNavVC", sender: self)
    }
    
    private func navigateToAquariumLighting(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "AquariumLighting")
        self.performSegue(withIdentifier: "SettingsNavVC", sender: self)
    }
    
    private func navigateToFeederMode(_ sender: Row){
        brain.setNavigatingTo(NavigatingTo: "FeederMode")
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
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        let formattedTime = timeFormatter.string(from: timePicker.date)
        brain.setSunriseTime(SunriseTime: formattedTime)
        
        self.setTableContents()
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            self.timePicker.alpha = 0.0
            self.pickerBackground.alpha = 0.0
            self.doneButton.alpha = 0.0
        })
    }
    
}

//
//  SettingsVC.swift
//  reef
//
//  Created by Conor Sheehan on 9/4/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
  
  let rowsPerSection = [3, 4, 3]
  let sectionHeaders = ["WI-FI SETTINGS", "REEF SETTINGS", "PROFILE SETTINGS"]
  let rowTitles = [["Last Connected", "Connected To", ""], ["pH Range", "Sunrise",
                  "Grow Stage", ""], ["Email", "First Name", "Reef ID"]]
  
  var rowValues = [["", "", "Reset Wi-Fi >"], ["6.2-6.8", "7 AM",
  "3", "Drain Tank >"], ["csheehan232@gmail.com", "Conor", "Reef-0004"]]
  let growStages = ["Inactive", "Cycling", "Seedling", "Vegetative", "Flowering", "Drying"]
  let greenColor = UIColor(red: 0.59, green: 0.69, blue: 0.62, alpha: 1.0)
  
  @IBOutlet weak var tableView: UITableView!
  weak var appDelegate: AppDelegate!
  
    override func viewDidLoad() {
      super.viewDidLoad()

      if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
        appDelegate = appDeleg
      }
      
      updateSettingsData()
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateSettingsData),
      name: NSNotification.Name(rawValue: "updatedSettingsData"), object: nil)
    }
  
  @objc func updateSettingsData() {
    let lastConnected = appDelegate.appBrain.reefSettings.lastConnected?.getLastConnectedString()
    let sunriseStr = appDelegate.appBrain.reefSettings.sunrise ?? "6:30 AM"
    let growStage = growStages[appDelegate.appBrain.reefSettings.growStage ?? 0]
    rowValues[0][0] = lastConnected ?? ""
    rowValues[0][1] = appDelegate.appBrain.reefSettings.ssid ?? ""
    rowValues[1][1] = sunriseStr.converStringToTime()
    rowValues[1][2] = growStage
    rowValues[2][0] = appDelegate.appBrain.userData.email ?? ""
    tableView.reloadData()
  }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowsPerSection[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let settingsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as? SettingsCell
    settingsCell?.titleLabel.text = rowTitles[indexPath.section][indexPath.row]
    settingsCell?.valueLabel.text = rowValues[indexPath.section][indexPath.row]
    if (indexPath.row == 2 && indexPath.section == 0) || (indexPath.row == 3 && indexPath.section == 1) {
      settingsCell?.valueLabel.font = UIFont.init(name: "AvenirNext-DemiBold", size: 17)
      settingsCell?.valueLabel.textColor = greenColor
    } else {
      settingsCell?.valueLabel.font = UIFont.init(name: "AvenirNext-Regular", size: 17)
      settingsCell?.valueLabel.textColor = UIColor.lightGray
      settingsCell?.selectionStyle = .none
    }
    return settingsCell!
    
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 25
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionHeaders[section]
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    view.tintColor = .white
    header.textLabel?.font = UIFont.init(name: "AvenirNext-UltraLight", size: 15)
    header.textLabel?.frame = header.frame
  }
  
  func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    view.tintColor = .white
  }

}

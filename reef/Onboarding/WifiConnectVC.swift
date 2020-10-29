//
//  WifiConnectVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/11/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import NetworkExtension
import SafariServices
import SystemConfiguration.CaptiveNetwork
import Rswift

class WifiConnectVC: UIViewController {

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var connectWifiButton: UIButton!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var subHeaderLabeel: UILabel!
  
  let reefConnectSSID = "Reef-Connect"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Hide activity indicator
    activityIndicator.isHidden  = true

    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.appBrain.readWiFiStatus {
        self.wifiConnected()
        appDelegate.appBrain.finishConnectingWifi()
      }
    }
  }

  @objc func wifiConnected() {

    print("Wifi was successfully connected")
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
    headerLabel.text = "Connected!"
    subHeaderLabeel.text = "Reef is now successfully connected to your Wi-Fi network."
    connectWifiButton.setTitle("Complete setup", for: .normal)
  }

  func startActivityIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    connectWifiButton.isEnabled = false
    connectWifiButton.setTitle("", for: .normal)
  }

  func stopActivityIndicator() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    connectWifiButton.isEnabled = true
    connectWifiButton.setTitle("Connect Wi-Fi", for: .normal)
  }
  
  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func connectToWifi(_ sender: Any) {

    if connectWifiButton.title(for: .normal) == "Connect Wi-Fi" {

      startActivityIndicator()

      let hotspotConfig = NEHotspotConfiguration(ssid: reefConnectSSID) // Unsecured connections
      hotspotConfig.joinOnce = false

      NEHotspotConfigurationManager.shared.apply(hotspotConfig) { [unowned self] (error) in

        self.stopActivityIndicator()

         if let connectionError = error {
          self.reefConnectFailed(withError: connectionError)
         } else {
          self.reefConnectAttemptComplete()
         }
      }
    } else {
      self.performSegue(withIdentifier: "segueToDashboardVC", sender: self)
    }
  }

  func reefConnectFailed(withError connectionError: Error) {

    if connectionError.localizedDescription == "already associated." {
      self.connectToAccessPoint()
      print("Already associated")
    } else {
      print("Error = ", connectionError.localizedDescription)
    }
  }

  func reefConnectAttemptComplete() {

    if self.currentSSIDs().first == reefConnectSSID {
      // Real success
      connectToAccessPoint()
      print("Success!")
    } else { print("Failed to connect") }
  }

  func connectToAccessPoint() {
    guard let reefConnectURL = URL(string: "http://192.168.4.1") else { return }
    let svc = SFSafariViewController(url: reefConnectURL)
    self.present(svc, animated: true, completion: nil)
  }

  func currentSSIDs() -> [String] {
      guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
          return []
      }
    return interfaceNames.compactMap { name in
          guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject] else {
              return nil
          }
          guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
              return nil
          }
          return ssid
      }
  }

}

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

class WifiConnectVC: UIViewController {

  @IBOutlet weak var wifiImage: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var connectWifiButton: UIButton!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var subHeaderLabeel: UILabel!

  let reefConnectSSID = "Reef-Connect"
  let generator = UINotificationFeedbackGenerator()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Hide activity indicator
    activityIndicator.isHidden  = true

    // Notify VC when re-entering Foreground from Background state
    NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(wifiConnected),
                                           name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
  }

  // De-initialize notification observer, when deconstructing class
  deinit { NotificationCenter.default.removeObserver(self) }

  override func viewDidAppear(_ animated: Bool) {
    startWifiAnimation()
  }

  @objc func willEnterForeground() {
    startWifiAnimation()

    // Check if user's Reef has successfully connected  to Wi-Fi

    // e.g Call firebase retrieval function for wi-fi connection with completion handler
  }

  @objc func wifiConnected() {

    print("Wifi was successfully connected")
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "wifiConnected"), object: nil)
    wifiImage.layer.removeAllAnimations()
    wifiImage.alpha = 1.0
    headerLabel.text = "Connected!"
    subHeaderLabeel.text = "Reef is now successfully connected to your home Wi-Fi network."
    connectWifiButton.setTitle("Complete setup", for: .normal)
  }

  func startWifiAnimation() {
    wifiImage.alpha = 0.15

    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
      self.wifiImage.alpha = 0.75
    })
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

    }
  }

  func reefConnectFailed(withError connectionError: Error) {

    if connectionError.localizedDescription == "already associated." {
      hapticFeedback(success: true)
      self.connectToAccessPoint()
      print("Already associated")
    } else {
      hapticFeedback(success: false)
      print("Error = ", connectionError.localizedDescription)
    }
  }

  func reefConnectAttemptComplete() {

    if self.currentSSIDs().first == reefConnectSSID {
      // Real success
      hapticFeedback(success: true)
      connectToAccessPoint()
      print("Success!")
    } else {
      // Failure
      hapticFeedback(success: false)
      print("Failed to connect")
    }
  }

  // NOT WORKING CURRENTLY
  func hapticFeedback(success: Bool) {
//    DispatchQueue.main.async {
//      self.generator.prepare()
//      if success { self.generator.notificationOccurred(.success) }
//      else { self.generator.notificationOccurred(.error )}
//    }
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

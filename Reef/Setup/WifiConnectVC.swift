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

class WifiConnectVC: UIViewController {

  @IBOutlet weak var wifiImage: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var connectWifiButton: UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    activityIndicator.isHidden  = true
    
    NotificationCenter.default.addObserver(self, selector:#selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    startWifiAnimation()
  }
  deinit {
      NotificationCenter.default.removeObserver(self)
  }
  
  func startWifiAnimation() {
    wifiImage.alpha = 0.15
    
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse,.curveEaseInOut], animations: {
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
  
  @objc func willEnterForeground() {
    startWifiAnimation()
    
    // Check if user's Reef has successfully connected  to Wi-Fi
    
    // e.g Call firebase retrieval function for wi-fi connection with completion handler
    
  }
    
  @IBAction func goToSettings(_ sender: Any) {
    
    startActivityIndicator()
    
    let hotspotConfig = NEHotspotConfiguration(ssid: "Reef-Connect")//Unsecured connections
    hotspotConfig.joinOnce = false
    
    NEHotspotConfigurationManager.shared.apply(hotspotConfig) { [unowned self] (error) in
       if let error = error {
        
        if error.localizedDescription == "already associated." {
          self.stopActivityIndicator()
          self.connectToAccessPoint()
          print("Already associated")
        }
          print("error = ",error)
       }
       else {
        self.stopActivityIndicator()
        self.connectToAccessPoint()
        print("Success!")
        
       }
    }
  }
  
  func connectToAccessPoint() {
    guard let reefConnectURL = URL(string:  "http://192.168.4.1") else { return }
    let svc = SFSafariViewController(url: reefConnectURL)
    self.present(svc, animated: true, completion: nil)
  }
  

}

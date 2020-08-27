//
//  NotificationVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/11/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
    }

  @IBAction func turnOnNotifiications(_ sender: Any) {

    print("Attempting to turn on notifications")

    // Request access to turn on notifications
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

      appDelegate.activateRemoteNotifications(completion: { granted in

        if granted {
          appDelegate.appBrain.setFCMToken(token: appDelegate.FCMtoken) // Store messaging token
          print("Access was granted")
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToWifiConnectVC", sender: self)
          }
        } else {
          print("Access was not granted")
        }
      })

    }
  }
  
  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

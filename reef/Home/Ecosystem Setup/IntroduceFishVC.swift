//
//  IntroduceFishVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/27/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class IntroduceFishVC: UIViewController {
  
  weak var appDelegate: AppDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
  }
    
  @IBAction func goBack(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addedFish(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "Did you add fish?",
                                  message: "Tap below once you introduced your first fish to reef.",
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
        print("You've pressed cancel")
    }))

    alert.addAction(UIAlertAction(title: "Added!", style: .default, handler: { (_) in
      self.appDelegate.appBrain.completeTask(tasksComplete: 1, setupTask: true)
      self.navigationController?.popToRootViewController(animated: true)
     }))

    self.present(alert, animated: true, completion: nil)
    
  }
}

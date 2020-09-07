//
//  SeedSproutedVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/26/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class SeedSproutedVC: UIViewController {
  
  weak var appDelegate: AppDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
  }
  
  @IBAction func confirmLater(_ sender: UIButton) {
     navigationController?.popToRootViewController(animated: true)
   }
   @IBAction func goBack(_ sender: UIButton) {
     navigationController?.popViewController(animated: true)
   }
  
  @IBAction func seedSprouted(_ sender: UIButton) {
     let alert = UIAlertController(title: "Did you seed sprout?", message: "", preferredStyle: .alert)

     alert.addAction(UIAlertAction(title: "Sprouted!", style: .default, handler: { (_) in
      self.appDelegate.appBrain.completeGermination()
      self.navigationController?.popToRootViewController(animated: true)
     }))
    
    alert.addAction(UIAlertAction(title: "Seed never sprouted.", style: .destructive, handler: { (_) in
      self.appDelegate.appBrain.completeTask(tasksComplete: 0, setupTask: false)
     self.navigationController?.popToRootViewController(animated: true)
    }))

     alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
         print("You've pressed cancel")
     }))

    self.present(alert, animated: true, completion: nil)
  }
  
}

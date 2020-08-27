//
//  NutrientsVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class NutrientsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  @IBAction func completedStep(_ sender: UIButton) {
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDeleg.appBrain.completeTask(tasksComplete: 2)
    }
    self.performSegue(withIdentifier: "CyclingVC", sender: self)
  }
  
  @IBAction func goBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func setupLater(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
}

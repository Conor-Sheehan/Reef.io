//
//  PlantSeedVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/26/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class PlantSeedVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
  @IBAction func plantSeedLater(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
  @IBAction func goBack(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  @IBAction func plantedSeed(_ sender: UIButton) {
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDeleg.appBrain.germinateSeed()
      appDeleg.appBrain.completeTask(tasksComplete: 2, setupTask: false)
      self.performSegue(withIdentifier: "SeedSproutedVC", sender: self)
    }
  }
}

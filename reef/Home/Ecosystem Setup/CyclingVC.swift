//
//  CyclingVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class CyclingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func completeSetup(_ sender: Any) {
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDeleg.appBrain.completeFirstSetup()
    }
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func goBack(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func setupLater(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
}

//
//  FloweringVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/31/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class FloweringVC: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }
    
  @IBAction func goBack(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    if sender.direction == .right {
      navigationController?.popViewController(animated: true)
    }
  }

}

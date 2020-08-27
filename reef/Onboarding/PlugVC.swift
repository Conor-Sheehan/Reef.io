//
//  PlugVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/10/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class PlugVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

}

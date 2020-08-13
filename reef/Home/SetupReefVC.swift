//
//  SetupReefVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/12/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class SetupReefVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  @IBAction func backTapped(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
}

//
//  GerminateVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class ChooseYourGrowVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func backTapped(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func selectStrain(_ sender: UIButton) {
    self.performSegue(withIdentifier: "SelectStrainVC", sender: self)
  }
}

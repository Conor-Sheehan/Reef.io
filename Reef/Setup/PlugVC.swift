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
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
    
  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  
  

}


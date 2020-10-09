//
//  SeedTypeVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

class SeedTypeVC: UIViewController {

  @IBOutlet weak var seedTypeLabel: UILabel!
  @IBOutlet weak var regularButton: UIButton!
  @IBOutlet weak var feminizedButton: UIButton!
  @IBOutlet weak var autoFlowerButton: UIButton!
  weak var appDelegate: AppDelegate!
  
  let selectedButton = R.image.selectedSeedButton()
  let unSelectedButton = R.image.unselectedSeedButton()
  
  var seedType: SeedType = .regular
  
  override func viewDidLoad() {
      super.viewDidLoad()
      var strainName = ""
      var strainType = ""

     if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
        appDelegate = appDeleg
        strainName = appDeleg.appBrain.currentGrowData.strainName
        strainType = appDeleg.appBrain.currentGrowData.strainType
      }
    
      seedTypeLabel.text = strainName + "- " + strainType
    }
  
  @IBAction func selectedRegular(_ sender: UIButton) {
    resetButtonBackgrounds()
    regularButton.setBackgroundImage(selectedButton, for: .normal)
    seedType = .regular
  }
    
  @IBAction func selectedFeminized(_ sender: UIButton) {
    resetButtonBackgrounds()
    feminizedButton.setBackgroundImage(selectedButton, for: .normal)
    seedType = .feminized
  }
  
  @IBAction func selectedAutoFlower(_ sender: UIButton) {
    resetButtonBackgrounds()
    autoFlowerButton.setBackgroundImage(selectedButton, for: .normal)
    seedType = .autoFlower
  }
  
  func resetButtonBackgrounds() {
    regularButton.setBackgroundImage(unSelectedButton, for: .normal)
    feminizedButton.setBackgroundImage(unSelectedButton, for: .normal)
    autoFlowerButton.setBackgroundImage(unSelectedButton, for: .normal)
  }
  
  @IBAction func selectSeedType(_ sender: UIButton) {
    appDelegate.appBrain.selectSeedType(type: seedType)
    appDelegate.appBrain.completeTask(tasksComplete: 1, setupTask: false)
    self.performSegue(withIdentifier: "PlantSeedVC", sender: self)
  }
  
  @IBAction func goBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

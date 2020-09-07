//
//  EcosystemVC.swift
//  reef
//
//  Created by Conor Sheehan on 9/2/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

class EcosystemVC: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textBox: UITextView!
  @IBOutlet weak var firstHeaderLabel: UILabel!
  @IBOutlet weak var firstSubheaderLabel: UILabel!
  @IBOutlet weak var secondHeaderLabel: UILabel!
  @IBOutlet weak var secondSubheaderLabel: UILabel!
  @IBOutlet weak var getStartedButton: UIButton!
  
  var currentSetupStage: AppBrain.EcosystemSetupStage = .firstSetup
  var setupTasksComplete: Int = 0
  let segue = R.segue.ecosystemVC.self
  let cyclingText: String = "Cycling your aquarium is essential to having a thriving ecosystem.\n\n"
  + "Wait until cycling is complete to introduce fish.\n\n"
  + "Cycling is the process of developing healthy bacteria in your tank.\n\n"
  + "These healthy bacteria filter the water and convert fish waste into nutrients for your plant.\n\n"
  + "These bacteria are the key to a self-sustaining ecosystem.\n\n"
  + "During cycling, reef will auto-dose ammonia to the tank to stimulate their natural growth cycle."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let growTracker = appDelegate.appBrain.growTracker
      currentSetupStage = growTracker.currentSetupStage
      setupTasksComplete = growTracker.setupTasksComplete
    }
    
    setPrimaryUI()
    setButtonActions()
  }
  
  func setPrimaryUI() {
    if currentSetupStage == .cycling {
      titleLabel.text = "Cycling Stage"
      textBox.text = cyclingText
      firstHeaderLabel.text = "14"
      firstSubheaderLabel.text = "Days"
      secondHeaderLabel.text = "Cycling"
      secondSubheaderLabel.text = "Dosing Solution"
    }
  }
  
  func setButtonActions() {
    var buttonTitle = ""
    switch currentSetupStage {
    case .cycling:
      buttonTitle = "InProgress"
      getStartedButton.isEnabled = false
    case .firstSetup:
      getStartedButton.isEnabled = true
      if setupTasksComplete == 0 { buttonTitle = "Start setup"
      } else if setupTasksComplete == 1 { buttonTitle = "Continue setup"
      } else { buttonTitle = "Finish setup" }
    case .introduceFish:
      if setupTasksComplete == 0 {
        getStartedButton.isEnabled = true
        buttonTitle = "Add Fish"
      } else {
        getStartedButton.isEnabled = false
        buttonTitle = "Complete"
      }
    default:
      print("Nothing here")
    }
    getStartedButton.setTitle(buttonTitle, for: .normal)
    
  }
    
  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
    if sender.direction == .right {
      navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    switch currentSetupStage {
    case .firstSetup:
      if setupTasksComplete == 0 { segue(to: segue.setupReefVC.identifier)
       } else if setupTasksComplete == 1 { segue(to: segue.nutrientsVC.identifier)
       } else if setupTasksComplete == 2 { segue(to: segue.cyclingVC.identifier) }
    case .introduceFish:
       if setupTasksComplete == 0 { segue(to: segue.introduceFishVC.identifier)
       } else { print("Add standard ecosystem screen for when setup is complete") }
    default:
       print("Do nothing for now")
     }
  }
  
  func segue(to viewcontroller: String) {
     self.performSegue(withIdentifier: viewcontroller, sender: self)
   }
  
}

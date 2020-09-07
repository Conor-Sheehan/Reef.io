//
//  GerminationVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/30/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

class GerminationVC: UIViewController {
  
  private var growTasksComplete: Int = 0
  private var currentGrowStage: AppBrain.ReefGrowStage = .ecosystemSetup
  private var stageStatus: StageStatus = .future
  private var segues = R.segue.germinationVC.self
  @IBOutlet weak var getStartedButton: UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      growTasksComplete = appDeleg.appBrain.growTracker.growTasksComplete
      currentGrowStage = appDeleg.appBrain.growTracker.currentGrowStage
      stageStatus = appDeleg.appBrain.getStageStatus(stage: .germinate)
      
      if appDeleg.appBrain.getStageStatus(stage: currentGrowStage) == .completed {
        self.getStartedButton.setTitle("Complete", for: .normal)
        self.getStartedButton.isEnabled = false
      }
      setButtonTitle()
    }

  }
  
  func setButtonTitle() {
    switch stageStatus {
    case .future:
      self.getStartedButton.setTitle("Get started", for: .normal)
      self.getStartedButton.isEnabled = false
    case .inProgress:
      if growTasksComplete == 0 { self.getStartedButton.setTitle("Get started", for: .normal)
      } else if growTasksComplete == 1 { self.getStartedButton.setTitle("Germinate seed", for: .normal)
      } else { self.getStartedButton.setTitle("Complete germination", for: .normal) }
    case .completed:
      self.getStartedButton.setTitle("Complete", for: .normal)
      self.getStartedButton.isEnabled = false
    }
  }

  @IBAction func goBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
    if sender.direction == .right {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @IBAction func getStarted(_ sender: UIButton) {
    if growTasksComplete == 0 { segue(to: segues.chooseYourGrowVC.identifier)
    } else if growTasksComplete == 1 { segue(to: segues.plantSeedVC.identifier)
    } else { segue(to: segues.seedSproutedVC.identifier) }
  }
  
  @IBAction func learnMore(_ sender: UIButton) {
  }

  func segue(to viewcontroller: String) {
    self.performSegue(withIdentifier: viewcontroller, sender: self)
  }
}

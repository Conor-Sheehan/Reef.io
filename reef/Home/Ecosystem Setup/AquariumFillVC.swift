//
//  AquariumFillVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/12/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class AquariumFillVC: UIViewController {

  @IBOutlet weak var waterLevelView: UIView!
  @IBOutlet weak var waterLevelBar: UIImageView!
  @IBOutlet weak var percentComplete: UILabel!
  @IBOutlet weak var waterLevelIcon: UIImageView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  private weak var appDelegate: AppDelegate!
  
  let maxWaterLevel: Float = 12
  let generator = UINotificationFeedbackGenerator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
    
    waterLevelView.frame = CGRect(x: waterLevelBar.frame.minX - 25,
    y: waterLevelBar.frame.maxY,
    width: waterLevelBar.frame.width + 50,
    height: 0)
    
    addNotificationObservers()
  }
  
  func readWaterLevel() {
    
    appDelegate.appBrain.readWaterLevel(completion: { waterLevel in

      var percentTankFilled = Int(Float(waterLevel)/self.maxWaterLevel*100)
      if percentTankFilled >= 100 { percentTankFilled = 100; self.finishedFillingTank() }
      self.animateWaterLevel(percentComplete: percentTankFilled)
    })
  }
  
  func finishedFillingTank() {
    nextButton.isEnabled = true
    progressIndicator.stopAnimating()
    progressIndicator.isHidden = true
    nextButton.setTitle("Next", for: .normal)
    waterLevelIcon.image = R.image.waterLevelIconWhite()
    generator.notificationOccurred(.success)
    updateDataModel()
  }
  
  func updateDataModel() {
    appDelegate.appBrain.completeTask(tasksComplete: 1, setupTask: true)
    appDelegate.appBrain.finishReadingWaterLevel()
  }
  
  func enableFillingTank(enabled: Bool) {
    appDelegate.appBrain.enableTankFilling(isEnabled: enabled)
  }
  
  func animateWaterLevel(percentComplete: Int) {
    let waterLevelBarHeight = waterLevelBar.frame.height
    let heightToIncrease = waterLevelBarHeight * CGFloat(percentComplete)/100
    
    UIView.animate(withDuration: 1.0,
    animations: {
      self.waterLevelView.frame = CGRect(x: self.waterLevelBar.frame.minX - 25,
                                         y: self.waterLevelBar.frame.maxY-heightToIncrease,
                                         width: self.waterLevelBar.frame.width + 50,
                                         height: heightToIncrease)
      self.percentComplete.text = String(percentComplete) + "%"
    })
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func goToNextStep(_ sender: UIButton) {
    self.performSegue(withIdentifier: "NutrientsVC", sender: self)
  }
  @IBAction func setupLater(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
  
}

// Handle View Controller State Changes
extension AquariumFillVC {
  
  func addNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.appearFromBackground),
                                           name: UIApplication.willEnterForegroundNotification, object: nil)
    if #available(iOS 13.0, *) {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive),
                                               name: UIScene.willDeactivateNotification, object: nil)
    } else {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive),
                                               name: UIApplication.willResignActiveNotification, object: nil)
    }
  }
  
  // Handle view appearing and dissapearing to enable/disable tank filling
  @objc func appearFromBackground() {
    progressIndicator.startAnimating()
    enableFillingTank(enabled: true)
    readWaterLevel()
  }
  @objc func willResignActive() { enableFillingTank(enabled: false); progressIndicator.stopAnimating() }
  override func viewDidAppear(_ animated: Bool) {
    waterLevelView.frame = CGRect(x: waterLevelBar.frame.minX - 25,
                                  y: waterLevelBar.frame.maxY,
                                  width: waterLevelBar.frame.width + 50,
                                  height: 0)
    progressIndicator.startAnimating()
    enableFillingTank(enabled: true)
    readWaterLevel()
  }
}

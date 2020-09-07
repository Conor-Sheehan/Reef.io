//
//  DashboardVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/5/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
  
//  fileprivate var sensorData: [CurrentSensorData] = []
//  fileprivate var growTrackerData: [ReefStageData] = []
//
//  @IBOutlet weak var headerLabel: UILabel!
//  @IBOutlet weak var subHeaderLabel: UILabel!
//  @IBOutlet weak var indicatorView: UIView!
//  @IBOutlet weak var collectionView: UICollectionView!
//  @IBOutlet weak var growStepTableView: UITableView!
//  @IBOutlet weak var growTrackerButton: UIButton!
//  @IBOutlet weak var growTrackerView: UIView!
//  @IBOutlet weak var reefTipsView: UIView!
//
//  private weak var appDelegate: AppDelegate!
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
//      appDelegate = appDeleg
//    }
//
//    sensorData = appDelegate.appBrain.getCurrentSensorData()
//    //growTrackerData = appDelegate.appBrain.getGrowTrackerData()
//    layoutViews()
//  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    loadSensorData()
//    loadGrowStepData()
//    navigationController?.navigationBar.isHidden = true
//  }
//
//  func layoutViews() {
//    indicatorView.layer.cornerRadius = 12
//    growTrackerView.layer.cornerRadius = 12
//    reefTipsView.layer.cornerRadius = 12
//    collectionView.backgroundColor = .clear
//    collectionView.delegate = self
//    collectionView.dataSource = self
//    growStepTableView.separatorStyle = .none
//    growStepTableView.rowHeight = 60
//  }
//
//  func loadSensorData() {
//
//    // Read reef Sensor data from Firebase and display on completion
//    appDelegate.appBrain.readSensorData(completion: {
//      self.sensorData = self.appDelegate.appBrain.getCurrentSensorData()
//      self.collectionView.reloadData()
//    })
//  }
//
//  func loadGrowStepData() {
//    appDelegate.appBrain.readGrowTrackerData(completion: {
//
//      //self.growTrackerData = self.appDelegate.appBrain.getGrowTrackerData()
//      self.growStepTableView.reloadData()
//      //self.scrollToGrowStep(currStep: self.appDelegate.appBrain.growTracker.currentStage)
//      self.growTrackerButton.isEnabled = true
//      print("Got grow tracker data")
//    })
//  }
//
//  func scrollToGrowStep(currStep: Int) {
//    let scrollToStep = currStep < self.growTrackerData.count - 2 ? currStep + 2 : self.growTrackerData.count - 1
//    let indexPath: IndexPath = IndexPath(row: scrollToStep, section: 0)
//    growStepTableView.scrollToRow(at: indexPath, at: .none, animated: true)
//  }
//
//  @IBAction func simulateCompleteStep(_ sender: UIButton) {
////    let currentGrowStep = appDelegate.appBrain.growTracker.getCurrentStage()
////    let currentTask = appDelegate.appBrain.growTracker.getTasksComplete()
////
////    switch currentGrowStep {
////    case .firstSetup:
////      segueToSetup(currentTask: currentTask)
////    case .germinate:
////      segueToGerminate(currentTask: currentTask)
////    case .introduceFish:
////      self.performSegue(withIdentifier: "IntroduceFishVC", sender: self)
////    default:
////      print("I dont know yet..")
////    }
//
//  }
//
//  func segueToSetup(currentTask: Int) {
//    switch currentTask {
//    case 1:
//      self.performSegue(withIdentifier: "NutrientsVC", sender: self)
//    case 2:
//      self.performSegue(withIdentifier: "CyclingVC", sender: self)
//    default:
//      self.performSegue(withIdentifier: "SetupReefVC", sender: self)
//    }
//  }
//
//  func segueToGerminate(currentTask: Int) {
//    switch currentTask {
//    case 1:
//      self.performSegue(withIdentifier: "PlantSeedVC", sender: self)
//    case 2:
//      self.performSegue(withIdentifier: "SeedSproutedVC", sender: self)
//    default:
//      self.performSegue(withIdentifier: "GerminateVC", sender: self)
//    }
//  }
//
//}
//
//// Handle Sensor Data Collection View
//extension DashboardVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//      return CGSize(width: collectionView.frame.width/3.2, height: collectionView.frame.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sensorData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
//        "SensorDataCell", for: indexPath) as? SensorDataCell
//      cell?.data = self.sensorData[indexPath.item]
//      return cell!
//    }
//}
//
//// Handle Grow Progress Table View
//extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return appDelegate.appBrain.growTracker.getNumberStages()
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "ReefStageCell", for: indexPath) as? ReefStageCell
//    cell?.data = self.growTrackerData[indexPath.item]
//    return cell!
//  }
  
}

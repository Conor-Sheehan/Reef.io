//
//  DashboardVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/5/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
  
  fileprivate var sensorData: [SensorData] = []
  fileprivate var growStepData: [GrowStepData] = []
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var subHeaderLabel: UILabel!
  @IBOutlet weak var indicatorView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var growStepTableView: UITableView!
  
  private weak var appDelegate: AppDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
    
    sensorData = appDelegate.appBrain.getCurrentSensorData()

    layoutViews()
    loadSensorData()
    loadProgressData()
  }
  
  func layoutViews() {
    indicatorView.layer.cornerRadius = 6
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    growStepTableView.separatorStyle = .none
    growStepTableView.rowHeight = 60
    
    //let indexPath: IndexPath = IndexPath(row: 4, section: 0)
    //self.progressTableView.scrollToRow(at: indexPath, at: .none, animated: true)
  }
  
  func loadSensorData() {
    
    // Read reef Sensor data from Firebase and display on completion
    appDelegate.appBrain.readReefData(completion: {
      
      self.sensorData = self.appDelegate.appBrain.getCurrentSensorData()
      self.collectionView.reloadData()
    })
  }
  
  func loadProgressData() {
    
    growStepData = appDelegate.appBrain.getGrowStepData()
    growStepTableView.reloadData()
  }
  
}

// Handle Sensor Data Collection View
extension DashboardVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width/3.2, height: collectionView.frame.height)
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sensorData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
        "SensorDataCell", for: indexPath) as? SensorDataCell
      cell?.data = self.sensorData[indexPath.item]
      return cell!
    }
}

// Handle Grow Progress Table View
extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return appDelegate.appBrain.growTracker.getNumberSteps()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GrowStepCell", for: indexPath) as? GrowStepCell
    cell?.data = self.growStepData[indexPath.item]
    return cell!
  }
  
}

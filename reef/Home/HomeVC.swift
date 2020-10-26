//
//  HomeVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/28/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

class HomeVC: UIViewController {
  
  fileprivate var growTrackerData: [ProgressData] = []
  private weak var appDelegate: AppDelegate!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var notificationIcon: UIButton!
  @IBOutlet weak var strainLabel: UILabel!
  
  private var homeSegues = R.segue.homeVC.self
  private var currentIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()

   if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
    
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    
    currentIndex = appDelegate.appBrain.growTracker.getCurrentStageIndex()
    
    //loadGrowTrackerData()
    NotificationCenter.default.addObserver(self, selector: #selector(self.loadGrowData),
                                           name: NSNotification.Name(rawValue: "readGrowTrackerData"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkNotificationStatus),
                                           name: UIApplication.didBecomeActiveNotification, object: nil)
    
    UserDefaults.standard.setValue(2, forKey: "setupLocation")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    loadGrowData()
    checkNotificationStatus()
  }
  
  @objc func checkNotificationStatus() {
    if UIApplication.shared.applicationIconBadgeNumber != 0 {
      notificationIcon.setImage(R.image.notificationsAlert(), for: .normal)
    } else {
      notificationIcon.setImage(R.image.notificationsUnselected(), for: .normal)
    }
  }
  
  @objc func loadGrowData() {
    let brain = appDelegate.appBrain
    
    // Update the collectionView data
    growTrackerData = brain?.getGrowTrackerData() ?? []
    self.collectionView.reloadData()
    
    // Check if user has already set current strain
    if brain?.currentGrowData.strainName != "" {
      strainLabel.text = brain?.currentGrowData.strainName ?? "" + " - " +
        (brain?.currentGrowData.strainType ?? "")
    } else { strainLabel.text = "" }
    
    // Scroll to index of current grow stage
    if brain?.growTracker.getCurrentStageIndex() != currentIndex {
      currentIndex = brain?.growTracker.getCurrentStageIndex() ?? 0
      // Scroll to current collectionview Cell
      let index = IndexPath(item: currentIndex, section: 0)
      collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    } else {
      let index = IndexPath(item: currentIndex, section: 0)
      collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
    
  }
  
  func handleCellSelect(index: Int) {
    switch index {
    case 0:
      segue(to: homeSegues.ecosystemVC.identifier)
    case 1:
      segue(to: homeSegues.germinationVC.identifier)
    case 2:
      segue(to: homeSegues.seedlingVC.identifier)
    case 3:
      segue(to: homeSegues.vegetativeVC.identifier)
    case 4:
      segue(to: homeSegues.floweringVC.identifier)
    default:
      print("Do nothing")
    }
    
  }
  
  func segue(to viewcontroller: String) {
    self.performSegue(withIdentifier: viewcontroller, sender: self)
  }

}

// Handle Sensor Data Collection View
extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width/1.5, height: collectionView.frame.height)
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growTrackerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
        "ProgressCell", for: indexPath) as? ProgressCell
      cell?.setNeedsLayout()
      cell?.layoutIfNeeded()
      cell?.data = self.growTrackerData[indexPath.item]
      return cell!
    }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Selected cell with index:", indexPath.item)
    handleCellSelect(index: indexPath.item)
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
      let cell = collectionView.cellForItem(at: indexPath)
      cell?.alpha = 0.5
  }

  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
      let cell = collectionView.cellForItem(at: indexPath)
      cell?.alpha = 1.0
  }
}

//
//  HomeVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/28/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift
import NVActivityIndicatorView

class HomeVC: UIViewController {
  
  fileprivate var growTrackerData: [ProgressData] = []
  private weak var appDelegate: AppDelegate!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var notificationIcon: UIButton!
  @IBOutlet weak var strainLabel: UILabel!
  @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
  @IBOutlet weak var loadingLabel: UILabel!
  @IBOutlet weak var currentGrowLabel: UILabel!
  @IBOutlet weak var growTipsView: UIView!
  
  private var homeSegues = R.segue.homeVC.self
  private var currentIndex = 0
  private var firstLoad = true
  
  override func viewDidLoad() {
    super.viewDidLoad()

   if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
    }
    
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    currentGrowLabel.isHidden = true
    growTipsView.isHidden = true
    
    currentIndex = appDelegate.appBrain.growTracker.getCurrentStageIndex()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.loadGrowData),
                                           name: NSNotification.Name(rawValue: "updatedGrowData"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkNotificationStatus),
                                           name: UIApplication.didBecomeActiveNotification, object: nil)
    
    UserDefaults.standard.setValue(2, forKey: "setupLocation")
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    if appDelegate.appBrain.growTracker.isDataLoaded {
      loadGrowData()
    } else {
      // Show loading animation
      loadingIndicator.startAnimating()
    }
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
    displayView()
    reloadGrowTrackerData()
    displayStrain()
    scrollToCell()
  }
  
  func displayView() {
    loadingIndicator.stopAnimating()
    currentGrowLabel.isHidden = false
    growTipsView.isHidden = false
    loadingLabel.isHidden = true
  }
  
  func displayStrain() {
    
    let brain = appDelegate.appBrain
    // Check if user has already set current strain
    if brain?.currentGrowData.strainName != "" {
      strainLabel.text = (brain?.currentGrowData.strainName ?? "") + " - " +
        (brain?.currentGrowData.strainType ?? "")
    } else { strainLabel.text = "" }
  }
  
  func scrollToCell() {
    if firstLoad {
      let brain = appDelegate.appBrain
      currentIndex = brain?.growTracker.getCurrentStageIndex() ?? 0
      // Scroll to current collectionview Cell
      let index = IndexPath(item: currentIndex, section: 0)
      collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
      firstLoad = false
    }
  }
  
  func reloadGrowTrackerData() {
    let brain = appDelegate.appBrain
    growTrackerData = brain?.getGrowTrackerData() ?? []
    self.collectionView.reloadData()
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
      
      cell?.data = self.growTrackerData[indexPath.item]
      //cell?.setNeedsLayout()
      cell?.layoutIfNeeded()
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

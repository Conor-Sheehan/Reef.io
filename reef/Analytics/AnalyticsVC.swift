//
//  AnalyticsVC.swift
//  reef
//
//  Created by Conor Sheehan on 10/20/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class AnalyticsVC: UIViewController {
  
  private weak var appDelegate: AppDelegate!

  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var progressBarBackground: UIView!
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var ecosytemLifeView: UIView!
  @IBOutlet weak var reefGrowsView: UIView!
  @IBOutlet weak var growHistoryView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var chartsView: UIView!
  @IBOutlet weak var reefGrowsLabel: UILabel!
  @IBOutlet weak var ecosystemLifeLabel: UILabel!
  
  var strainNames: [String] = []
  var strainTypes: [String] = []
  var startDate: [Date] = []
  var completeDate: [Date] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
       appDelegate = appDeleg
     }
      
    progressView.layer.cornerRadius = 12
    progressBarBackground.layer.cornerRadius = 4
    progressBar.layer.cornerRadius = 4
    reefGrowsView.layer.cornerRadius = 12
    ecosytemLifeView.layer.cornerRadius = 12
    growHistoryView.layer.cornerRadius = 12
    tableView.layer.cornerRadius = 12
    chartsView.layer.cornerRadius = 12
    progressBar.frame = CGRect(x: progressBarBackground.frame.minX,
                               y: progressBarBackground.frame.minY, width: 75,
                               height: progressBarBackground.frame.height)
    
    updateAnalyticsData()
    updateGrowHistory()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateGrowHistory),
                                           name: NSNotification.Name(rawValue: "updatedGrowData"), object: nil)
  }
  
  func updateAnalyticsData() {
    let brain = appDelegate.appBrain
    
    // Set number of completed grows
    let completedGrows = brain?.growTracker.completedGrows
    reefGrowsLabel.text = String(completedGrows ?? 0)
    
    // Set ecosystem life span (in days)
    let ecosystemLife = brain?.ecosystemData.ecosystemSetup
    ecosystemLifeLabel.text = String(ecosystemLife?.daysElapsed() ?? 0) + " Days"
  }
  
  @objc func updateGrowHistory() {
    let growHistory = appDelegate.appBrain.growHistory
    
    strainNames = growHistory.strainName ?? []
    strainTypes = growHistory.strainType ?? []
    startDate = growHistory.germinated ?? []
    completeDate = growHistory.growComplete ?? []
    
    tableView.reloadData()
    
  }
    
}

extension AnalyticsVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return strainNames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let strainCell = (tableView.dequeueReusableCell(withIdentifier: "StrainCell") as? StrainCell)!
    var growDuration = ""
    // Set strain name and type
    strainCell.strainName.text = strainNames[indexPath.row]
    strainCell.strainType.text = strainTypes[indexPath.row]
    
    // If grow hasnt completed yet, calculate days since start
    if !completeDate.indices.contains(indexPath.row) && startDate.indices.contains(indexPath.row) {
      growDuration = String(startDate[indexPath.row].daysElapsed()) + " Days"
      strainCell.yield.text = "In Progress"
    } else if completeDate.indices.contains(indexPath.row) {
      // Calculate length of grow in days between start and end date
      growDuration = "Need to calculate"
    } else { growDuration = "0 Days"; strainCell.yield.text = "Germinate seed" }
    
    strainCell.growDuration.text = growDuration
    
    return strainCell
  }
  
}

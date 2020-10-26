//
//  AnalyticsVC.swift
//  reef
//
//  Created by Conor Sheehan on 10/20/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class AnalyticsVC: UIViewController {

  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var progressBarBackground: UIView!
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var ecosytemLifeView: UIView!
  @IBOutlet weak var reefGrowsView: UIView!
  @IBOutlet weak var growHistoryView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var chartsView: UIView!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
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
    }
    
}

extension AnalyticsVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let strainCell = (tableView.dequeueReusableCell(withIdentifier: "StrainCell") as? StrainCell)!
    return strainCell
  }
  
}

//
//  ProgressCell.swift
//  reef
//
//  Created by Conor Sheehan on 8/5/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

struct GrowStepData {
  var stepName: String
  var tasksComplete: Int
  var numberOfTasks: Int
  var hasTasks: Bool
  var stepStatus: StepStatus // 0 for future, 1 for current, 2 for complete
  var daysLeft: Int
}

enum StepStatus { case completed, inProgress, future }

class GrowStepCell: UITableViewCell {
  
  @IBOutlet weak var progressImage: UIImageView!
  @IBOutlet weak var header: UILabel!
  @IBOutlet weak var subHeader: UILabel!
  @IBOutlet weak var lineImage: UIImageView!
  
  var data: GrowStepData? {
      didSet {
        guard let data = data else { return }
        
        switch data.stepStatus {
        case .future:
          progressImage.image = R.image.incompleteCircle()
          lineImage.image = R.image.incompleteLine()
          header.font = UIFont(name: "AvenirNext-Regular", size: 16)
          subHeader.text = ""
          header.textColor = .lightGray
        case .inProgress:
          progressImage.image = R.image.currentCircle()
          lineImage.image = R.image.incompleteLine()
          header.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
          header.textColor = .darkGray
          if data.hasTasks { subHeader.text = String(data.tasksComplete) +
            "/" + String(data.numberOfTasks) + " Steps Complete"
          } else { subHeader.text = String(data.daysLeft) + " Days Left" }
        case .completed:
          progressImage.image = R.image.completedCircle()
          lineImage.image = R.image.completedLine()
          header.font = UIFont(name: "AvenirNext-Regular", size: 16)
          header.textColor = .darkGray
          subHeader.textColor = UIColor(red: 0.18, green: 0.39, blue: 0.39, alpha: 1.0)
          if data.hasTasks { subHeader.text = String(data.numberOfTasks) +
            "/" + String(data.numberOfTasks) + " Steps Complete"
          } else { subHeader.text = "Completed" }
        }
        
        header.text = data.stepName
        if data.stepName == "Drying" { lineImage.alpha = 0.0 }
        
      }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
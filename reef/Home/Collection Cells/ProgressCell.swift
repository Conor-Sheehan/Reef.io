//
//  ProgressCell.swift
//  reef
//
//  Created by Conor Sheehan on 8/28/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Rswift

struct ProgressData {
  var index: Int
  var tasksComplete: Int
  var numberOfTasks: Int
  var status: StageStatus // 0 for future, 1 for current, 2 for complete
  var daysLeft: Int?
  var percentComplete: Float
  var setupStage: AppBrain.EcosystemSetupStage
  var dateComplete: Date?
}

enum StageStatus { case completed, inProgress, future }

class ProgressCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var progressBackground: UIView!
  @IBOutlet weak var progressSubheader: UILabel!
  @IBOutlet weak var progressHeader: UILabel!
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var actionImage: UIImageView!
  
  let cellTitles = ["Ecosystem", "Germination", "Seedling", "Vegetative", "Flowering", "Harvest"]
  let cellImages = [R.image.koi(), R.image.germinateImage(), R.image.seedTypeImage(), R.image.vegetative(),
                    R.image.cannabisLeaf(), R.image.harvest()]
  
  let greenColor = UIColor(red: 0.59, green: 0.69, blue: 0.62, alpha: 1.0)
  let blueColor = UIColor(red: 0.18, green: 0.39, blue: 0.39, alpha: 1.0)
  let check = R.image.check()
  let action = R.image.action()
  var percentComplete: Float = 0.0
  var index = 0
  var status: StageStatus = .future
  var numberOfTasks = 0
  var tasksComplete = 0
  var daysLeft = 0
  var setupStage: AppBrain.EcosystemSetupStage = .firstSetup
  var dateComplete: Date?
  
  var data: ProgressData? {
      didSet {
        guard let data = data else { return }
        titleLabel.text = cellTitles[data.index]
        image.image = cellImages[data.index]
        stylizeContentView()
        self.percentComplete = data.percentComplete
        self.index = data.index
        self.status = data.status
        self.numberOfTasks = data.numberOfTasks
        self.tasksComplete = data.tasksComplete
        self.daysLeft = data.daysLeft ?? 0
        self.setupStage = data.setupStage
        self.dateComplete = data.dateComplete
        
        setCellColor()
        setStatus()
        updateProgressBarLayout()
        setProgressHeaders()
        setSubtitle()
        setActionRequiredImage()
      }
  }
  
  func setActionRequiredImage() {
    if status == .inProgress && tasksComplete < numberOfTasks {
      actionImage.isHidden = false; actionImage.image = action
    } else if status == .completed {
      actionImage.isHidden = false; actionImage.image = check
    } else { actionImage.isHidden = true }
  }
  
  func setProgressHeaders() {
    if numberOfTasks != 0 {
      progressHeader.text = String(tasksComplete) + "/" + String(numberOfTasks)
      progressSubheader.text = "Steps Complete"
    } else {
      progressHeader.text = String(daysLeft)
      progressSubheader.text = "Days Left"
      if daysLeft == 0 {
        progressHeader.text = ""
        progressSubheader.text = "Stage Complete"
      }
    }
  }
  
  func setSubtitle() {
    switch index {
    case 0:
      setEcosystemSubtitle()
    case 1:
      setGerminationSubtitle()
    default:
      subtitleLabel.text = "Tap to learn more"
    }
  }
  
  func setEcosystemSubtitle() {
    switch setupStage {
    case .firstSetup:
      if tasksComplete == 0 { subtitleLabel.text = "Tap to begin setup"
      } else if tasksComplete == 1 { subtitleLabel.text = "Tap to continue setup"
      } else { subtitleLabel.text = "Tap to finish setup" }
    case .cycling:
      subtitleLabel.text = "Tank cycling in process..."
    case .introduceFish:
      if tasksComplete == 0 { subtitleLabel.text = "Tap to introduce fish"
      } else { subtitleLabel.text = "Setup Complete" }
    default:
      subtitleLabel.text = "Not handled yet"
    }
  }
  
  func setGerminationSubtitle() {
    if tasksComplete == 0 { subtitleLabel.text = "Tap to begin germination"
    } else if tasksComplete == 1 { subtitleLabel.text = "Tap to continue germination"
    } else if tasksComplete == 2 { subtitleLabel.text = "Tap to finish germination"
    } else { subtitleLabel.text = "Tap to learn more" }
  }
  
  func updateProgressBarLayout() {
    let progressBarWidth = progressBackground.frame.width * CGFloat(percentComplete)
    if index == 0 { progressBar.backgroundColor = greenColor
    } else { progressBar.backgroundColor = blueColor }
    
    progressBar.frame = CGRect(x: progressBackground.frame.minX,
    y: progressBackground.frame.minY,
    width: progressBarWidth,
    height: progressBackground.frame.height)
  }
  
  func setCellColor() {
    if index != 0 { self.contentView.backgroundColor = greenColor
    } else { self.contentView.backgroundColor = blueColor }
  }
  
  func setStatus() {
    if index != 0 && status == .future { self.contentView.alpha = 0.25
    } else { self.contentView.alpha = 1.0 }
  }
  
  func stylizeContentView() {
    progressBackground.layer.cornerRadius = 6
    self.contentView.layer.cornerRadius = 12
    progressBar.layer.cornerRadius = 6
  }
  
  override func layoutIfNeeded() {
    super.layoutIfNeeded()
  }
    
}

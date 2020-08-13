//
//  CustomIndicatorCell.swift
//  reef
//
//  Created by Conor Sheehan on 8/5/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import Foundation
import UIKit

struct CurrentSensorData {
  var value: String
  var index: Int
}

class SensorDataCell: UICollectionViewCell {
  
  let sensorDescriptions = ["Water Level", "Plant Height", "pH", "Air Temp", "Humidity", "Water Temp"]
  let sensorMetrics = [" in", " in", "", "°", "%", "°"]
  let sensorIcons = [R.image.waterLevelIcon()!, R.image.plantHeightIcon()!, R.image.phIcon()!,
                        R.image.airTempIcon()!, R.image.humidityIcon()!, R.image.waterTempIcon()!]
    
    var data: CurrentSensorData? {
        didSet {
          guard let data = data else { return }
          iconImage.image = sensorIcons[data.index]
          valueLabel.text = data.value
          descriptionLabel.text = sensorDescriptions[data.index]
        }
    }
  
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
}

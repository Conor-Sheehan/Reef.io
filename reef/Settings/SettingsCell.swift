//
//  SettingsCell.swift
//  reef
//
//  Created by Conor Sheehan on 9/4/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//
//  StrainCell.swift
//  reef
//
//  Created by Conor Sheehan on 10/21/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class StrainCell: UITableViewCell {
  
  @IBOutlet weak var strainName: UILabel!
  @IBOutlet weak var strainType: UILabel!
  @IBOutlet weak var growDuration: UILabel!
  @IBOutlet weak var yield: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

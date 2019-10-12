//
//  GuideCell.swift
//  Reef
//
//  Created by Conor Sheehan on 8/22/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit

class GuideCell: UITableViewCell {
 
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var imageTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

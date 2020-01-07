//
//  MenuTVCell.swift
//  Reef
//
//  Created by Conor Sheehan on 10/20/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit

class MenuTVCell: UITableViewCell {
    
    @IBOutlet weak var menuOptionTitle: UILabel!
    @IBOutlet weak var menuOptionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

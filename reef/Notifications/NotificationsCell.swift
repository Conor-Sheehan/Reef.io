//
//  NotificationsCell.swift
//  reef
//
//  Created by Conor Sheehan on 9/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

struct NotificationData {
  var title: String
  var subtitle: String
  var dateAdded: Date
}

class NotificationsCell: UITableViewCell {
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subTitle: UILabel!
  @IBOutlet weak var timeElapsed: UILabel!
  
  var data: NotificationData? {
      didSet {
        guard let data = data else { return }
        title.text = data.title
        subTitle.text = data.subtitle
        
        let daysElapsed = data.dateAdded.daysElapsed()
        if daysElapsed == 0 { timeElapsed.text = "Today" }
        else if daysElapsed < 7 { timeElapsed.text = String(daysElapsed) + "d" }
        else { timeElapsed.text = String (data.dateAdded.weeksElapsed()) + "w" }
      }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

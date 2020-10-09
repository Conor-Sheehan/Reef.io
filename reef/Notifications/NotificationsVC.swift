//
//  NotificationsVC.swift
//  reef
//
//  Created by Conor Sheehan on 9/24/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyNotificationsAlert: UIView!
  private weak var appDelegate: AppDelegate!
  private var tableviewData: [NotificationData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
      tableviewData = appDelegate.appBrain.notificationData.getData()
    }
    
    hideOrShowTableView()
    print("Notification data", tableviewData)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    tableviewData = []
    tableviewData = appDelegate.appBrain.notificationData.getData()
    tableView.reloadData()
  }
  
  func hideOrShowTableView() {
   if appDelegate.appBrain.notificationData.count() == 0 {
      tableView.isHidden = true
      emptyNotificationsAlert.isHidden = false
    } else {
      tableView.isHidden = false
      emptyNotificationsAlert.isHidden = true
    }
  }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return appDelegate.appBrain.notificationData.count()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let notificationsCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as? NotificationsCell
    notificationsCell?.data = tableviewData[indexPath.row]
    return notificationsCell!
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // Deleting notification data locally and in firebase
      appDelegate.appBrain.deleteNotification(at: indexPath.row)
      tableviewData = []
      tableviewData =  appDelegate.appBrain.notificationData.getData()
      
      hideOrShowTableView()
      tableView.reloadData()
    }
  }
  
}

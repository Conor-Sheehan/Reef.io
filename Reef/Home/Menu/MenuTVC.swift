//
//  MenuTVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/20/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {
    
    let menuOptions = ["Connection", "Basins", "Grow Guide", "Settings"]
    let menuImages = [ #imageLiteral(resourceName: "HomeVC Bluetooth Icon"), #imageLiteral(resourceName: "HomeVC Daylight Icon"), #imageLiteral(resourceName: "Menu Plant Icon"),#imageLiteral(resourceName: "Menu Settings Icon")]
    let segueIdentifiers = ["ConnectionVC", "BasinVC", "GrowStageVC", "SettingsVC"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuOptions.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell", for: indexPath) as! MenuTVCell
        
        let menuIndex = indexPath.row
        
        cell.menuOptionTitle.text = menuOptions[menuIndex]
        cell.menuOptionImage.image = menuImages[menuIndex]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = segueIdentifiers[indexPath.row]
        self.performSegue(withIdentifier: segue, sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

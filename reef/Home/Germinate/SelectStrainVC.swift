//
//  SelectStrainVC.swift
//  reef
//
//  Created by Conor Sheehan on 8/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class SelectStrainVC: UITableViewController, UISearchResultsUpdating {
  
  var strainData: [String] = []
  var filteredStrainData = [String]()
  var resultSearchController = UISearchController()
  
  weak var appDelegate: AppDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let appDeleg = UIApplication.shared.delegate as? AppDelegate {
      appDelegate = appDeleg
      strainData = appDeleg.appBrain.strainNames
    }
    
    resultSearchController = ({
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
      controller.searchBar.sizeToFit()
      controller.obscuresBackgroundDuringPresentation = false
      controller.hidesNavigationBarDuringPresentation = false
      tableView.tableHeaderView = controller.searchBar
      
      self.navigationItem.titleView = controller.searchBar

      return controller
    })()

    // Reload the table
    tableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  resultSearchController.isActive {
          return filteredStrainData.count
      } else {
          return strainData.count
      }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    filteredStrainData.removeAll(keepingCapacity: false)

    let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
    let array = (strainData as NSArray).filtered(using: searchPredicate)
    filteredStrainData = array as? [String] ?? []

    self.tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

      if resultSearchController.isActive {
          cell.textLabel?.text = filteredStrainData[indexPath.row]
      } else {
          cell.textLabel?.text = strainData[indexPath.row]
      }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var strainName = ""
    if resultSearchController.isActive {
        strainName = filteredStrainData[indexPath.row]
    } else {
        strainName = strainData[indexPath.row]
    }
    appDelegate.appBrain.selectStrain(name: strainName)
    self.performSegue(withIdentifier: "SeedTypeVC", sender: self)
  }
    
}

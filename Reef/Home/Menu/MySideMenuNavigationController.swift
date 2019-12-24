//
//  MySideMenuNavigationController.swift
//  Reef
//
//  Created by Conor Sheehan on 10/21/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import Foundation
import SideMenu

class MySideMenuNavigationController: SideMenuNavigationController {
    
    let customSideMenuManager = SideMenuManager()

    override func awakeFromNib() {
        super.awakeFromNib()

        sideMenuManager = customSideMenuManager
        
        sideMenuManager.leftMenuNavigationController?.presentationStyle = .menuSlideIn
    }
    
    
    
}

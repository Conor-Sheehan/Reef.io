//
//  TabBar.swift
//  Reef
//
//  Created by Conor Sheehan on 8/29/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
        
        override open func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = 100 // adjust your size here
            return sizeThatFits
        }
}

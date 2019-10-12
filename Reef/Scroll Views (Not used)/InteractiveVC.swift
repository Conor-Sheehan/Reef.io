//
//  InteractiveVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Hero

class InteractiveVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                let IntelligentVC = self.storyboard?.instantiateViewController(withIdentifier: "IntelligentVC") as! IntelligentVC
                IntelligentVC.isHeroEnabled = true
                IntelligentVC.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.right)
                self.hero_replaceViewController(with: IntelligentVC)
       
            default:
                break
            }
        }
    }
    


}

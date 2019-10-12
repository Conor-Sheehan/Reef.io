//
//  IntelligentVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Hero

class IntelligentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true

      
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeDown)
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
                let SynergisticVC = self.storyboard?.instantiateViewController(withIdentifier: "SynergisticVC") as! SynergisticVC
                SynergisticVC.isHeroEnabled = true
                SynergisticVC.heroModalAnimationType =  .push(direction: HeroDefaultAnimationType.Direction.right)
                self.hero_replaceViewController(with: SynergisticVC)
                print("Swiped left")

            case UISwipeGestureRecognizer.Direction.left:
                let InteractiveVC = self.storyboard?.instantiateViewController(withIdentifier: "InteractiveVC") as! InteractiveVC
                InteractiveVC.isHeroEnabled = true
                InteractiveVC.heroModalAnimationType = .push(direction: HeroDefaultAnimationType.Direction.left)
                self.hero_replaceViewController(with: InteractiveVC)
                print("Swiped left")
                print("Swiped left")

            default:
                break
            }
        }
    }

}

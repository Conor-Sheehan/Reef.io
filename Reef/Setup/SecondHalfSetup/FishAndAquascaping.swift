//
//  FishAndAquascaping.swift
//  Reef
//
//  Created by Conor Sheehan on 8/8/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox


class FishAndAquascaping: UIViewController  {
    
    @IBOutlet weak var HeadlineText: UILabel!
    @IBOutlet weak var FishGroup: UIImageView!
    @IBOutlet weak var InfoText: UILabel!
    @IBOutlet weak var LearnMoreButton: UIButton!
    @IBOutlet weak var AquascapeImage: UIImageView!
    @IBOutlet weak var FishSingle: UIImageView!
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    var viewTracker: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.curveEaseIn,.repeat, .autoreverse], animations: {
            self.FishGroup.center.y -= 5
            self.AquascapeImage.center.y -= 5
            self.FishSingle.center.y -= 5
        })
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
                
            case UISwipeGestureRecognizerDirection.left:
                if(viewTracker == 1){
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.InfoText.alpha = 0.5
                        self.HeadlineText.alpha = 0.5
                        self.FishGroup.alpha = 0.0
                    })
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                        self.InfoText.alpha = 1.0
                        self.HeadlineText.alpha = 1.0
                        self.InfoText.text = "Reef will automatically filter \n and purify the water to \n prepare it for new life."
                        self.HeadlineText.text = "Smart Ecosystem"
                        self.FishSingle.alpha = 1.0
                    })
                    self.sliderImage.image = #imageLiteral(resourceName: "Slider Circles2")
                    viewTracker += 1
                   
                }
                else if(viewTracker == 2){
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.InfoText.alpha = 0.5
                        self.HeadlineText.alpha = 0.5
                        self.FishSingle.alpha = 0.0
                    })
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                        self.InfoText.alpha = 1.0
                        self.HeadlineText.alpha = 1.0
                        self.InfoText.text = "Aquascaping brings life to your \n ecosystem and offers hiding spots \n for your fish to reduce stress"
                        self.HeadlineText.text = "Aquascaping"
                        self.AquascapeImage.alpha = 1.0
                        self.continueButton.alpha = 1.0
                    })
               
                    self.sliderImage.image = #imageLiteral(resourceName: "Slider Circles3")
                    viewTracker += 1
                    
              
                 
                }
                
            case UISwipeGestureRecognizerDirection.right:
                if(viewTracker == 2){
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.InfoText.alpha = 0.5
                        self.HeadlineText.alpha = 0.5
                        self.FishSingle.alpha = 0.0
                    })
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                        self.InfoText.alpha = 1.0
                        self.HeadlineText.alpha = 1.0
                        self.InfoText.text = "We recommend waiting 2-3 \n days before introducing fish \n to your ecosystem."
                        self.HeadlineText.text = "Introducing Fish"
                        self.FishGroup.alpha = 1.0
                    })
             
                    self.sliderImage.image = #imageLiteral(resourceName: "Slider Circles1")
                    viewTracker -= 1
                    
                }
                
                else if(viewTracker == 3){
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.InfoText.alpha = 0.5
                        self.HeadlineText.alpha = 0.5
                        self.AquascapeImage.alpha = 0.0
                        self.continueButton.alpha = 0.0
                    })
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: {
                        self.InfoText.alpha = 1.0
                        self.HeadlineText.alpha = 1.0
                            self.InfoText.text = "Reef will automatically filter \n and purify the water to \n prepare it for new life."
                        self.HeadlineText.text = "Smart Aquaponics"
                        self.FishSingle.alpha = 1.0
                        
                    })
               
                    self.sliderImage.image = #imageLiteral(resourceName: "Slider Circles2")
                    viewTracker -= 1
                    
                }
            default:
                break
            }
        }
    }
    
    @IBAction func ContinueTapped(_ sender: UIButton) {
        let FeederVC = self.storyboard?.instantiateViewController(withIdentifier: "FeederAndBasin") as! FeederAndBasin
        FeederVC.isHeroEnabled = true
        FeederVC.heroModalAnimationType = .push(direction: .left)
        self.hero_replaceViewController(with: FeederVC)
    
    }
    
}

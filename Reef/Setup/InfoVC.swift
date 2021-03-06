//
//  InfoVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/8/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    
    let infoTitles = ["Introducing Fish.", "Cycle.", "Plant New Life."]
    let infoDescriptions = ["We reccomend waiting 2-3 days after setting up Reef to introduce new life.",
                            "During this time, Reef will cycle and filter the water to prepare it for your fish farmers.",
                            "You may take this time to begin planting the seeds you wish to grow."]
    let infoImages: [UIImage] = [#imageLiteral(resourceName: "Fish Group"), #imageLiteral(resourceName: "Fish single"),#imageLiteral(resourceName: "HomeVC Start Grow Image")]
    let sliderImages: [UIImage] = [ #imageLiteral(resourceName: "Slider Circles1"), #imageLiteral(resourceName: "Slider Circles2"), #imageLiteral(resourceName: "Slider Circles3")]
    
    var tracker = 0
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var completeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizers()
        completeButton.alpha = 0.0
        
        // Set setup location identifier to 6
        UserDefaults.standard.set(6, forKey: "setupLocation")
    }
    
    func addGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    @IBAction func completeSetup(_ sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = homeViewController
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            // User swipes to the left
            case UISwipeGestureRecognizer.Direction.left:
                if tracker == 0 || tracker == 1 {
                    tracker += 1
                    titleText.text = infoTitles[tracker]
                    descriptionText.text = infoDescriptions[tracker]
                    image.image = infoImages[tracker]
                    sliderImage.image = sliderImages[tracker]
                }
                if tracker == 2 { completeButton.alpha = 1.0 }
            // User swipees to the right
            case UISwipeGestureRecognizer.Direction.right:
                if tracker == 1 || tracker == 2 {
                    tracker -= 1
                    titleText.text = infoTitles[tracker]
                    descriptionText.text = infoDescriptions[tracker]
                    image.image = infoImages[tracker]
                    sliderImage.image = sliderImages[tracker]
                    completeButton.alpha = 0.0
                }
                
            default: break
                
            }
        }
        
    }
                
    

}

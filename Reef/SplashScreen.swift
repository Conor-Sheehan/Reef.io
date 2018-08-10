//
//  ViewController.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Hero


class SplashScreen: UIViewController {
    @IBOutlet weak var infinitryLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infinitryLogo.alpha = 0.0
        self.isHeroEnabled = true
        

          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            
            // if user is here for the first time
            if(UserDefaults.standard.object(forKey: "loggedIn") == nil){
                let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                welcomeVC.isHeroEnabled = true
                welcomeVC.heroModalAnimationType = .fade
                self.hero_replaceViewController(with: welcomeVC)
            }
            
                else{
                // We are going to direct user to dashboard
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Animate logo
        UIView.animate(withDuration: 0.6, delay: 0.3, options: [.curveEaseIn], animations: {
            self.infinitryLogo.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 0.6, options: [.curveEaseOut], animations: {
                self.infinitryLogo.alpha = 0.0
                   })
        })
    
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


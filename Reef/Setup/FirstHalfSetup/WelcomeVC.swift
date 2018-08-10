//
//  WelcomeVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Hero

class WelcomeVC: UIViewController {
    @IBOutlet weak var plantNewBegginings: UILabel!
    @IBOutlet weak var restoreBalance: UILabel!
    @IBOutlet weak var Thrive: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHeroEnabled = true
        self.restoreBalance.alpha = 0.0
        self.plantNewBegginings.alpha = 0.0
        self.Thrive.alpha = 0.0
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .autoreverse,.repeat], animations: {
            self.plantNewBegginings.alpha = 1.0
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.3, options: [.curveEaseInOut, .autoreverse,.repeat], animations: {
            self.restoreBalance.alpha = 1.0
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.6, options: [.curveEaseInOut, .autoreverse,.repeat], animations: {
            self.Thrive.alpha = 1.0
        })
        
    }
    
    @IBAction func Join(_ sender: UIButton) {
        
        let SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        SignUpVC.isHeroEnabled = true
        SignUpVC.heroModalAnimationType = .push(direction: .left)
        self.hero_replaceViewController(with: SignUpVC)
        
    }
    
    
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}



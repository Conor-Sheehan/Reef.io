//
//  FeederRefillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/31/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit

class FeederRefillVC: UIViewController {
    @IBOutlet weak var feederPercent: UILabel!
    @IBOutlet weak var feederModule: UIImageView!
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    var feederLevel: Int = 0
    
    var brain: AppBrain!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the app delegate to activate instabug and access app delegate data model singleton
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            brain = appDelegate.appBrain
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        self.title = "Fish Feeder"
        // Do any additional setup after loading the view.
        
        self.feederLevel = brain.getBasinLevels().feederLvl
        print("Feeder level ", self.feederLevel)
        self.feederPercent.text = String(feederLevel) + "%"
        
        self.drawCircles()
        self.animateCircle()
        
    
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func refillFeeder(_ sender: UIButton) {
    }
  

}

extension FeederRefillVC {
    func drawCircles(){
        let center = CGPoint(x: feederModule.frame.origin.x + (feederModule.frame.width*0.84), y: feederModule.frame.origin.y + (feederModule.frame.height*0.5))
        
        let startangle = CGFloat.pi
        let endangle = startangle + 2*CGFloat.pi
        
        var circularPath = UIBezierPath(arcCenter: center, radius: 32, startAngle: startangle, endAngle: endangle, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red:0.32, green:0.69, blue:0.67, alpha:1.0).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = Double(self.feederLevel)/100.0
        basicAnimation.duration = 1.0
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}

//
//  AquariumRefillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/31/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit

class AquariumRefillVC: UIViewController {
    @IBOutlet weak var aquariumPercent: UILabel!
    @IBOutlet weak var growTankModule: UIImageView!
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    var brain: AppBrain!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the app delegate to activate instabug and access app delegate data model singleton
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            brain = appDelegate.appBrain
        }

        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
         self.title = "Aquarium"
        // Do any additional setup after loading the view.
        
        self.aquariumPercent.text = String(brain.aquariumLevel) + "%"
        
        self.drawCircles()
        self.animateCircle()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func refillAquarium(_ sender: UIButton) {
    }


}

extension AquariumRefillVC {
    func drawCircles(){
        let center = CGPoint(x: growTankModule.frame.origin.x + (growTankModule.frame.width*0.84), y: growTankModule.frame.origin.y + (growTankModule.frame.height*0.5))
        
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
        basicAnimation.toValue = Double(brain.aquariumLevel)/100.0
        basicAnimation.duration = 1.0
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}

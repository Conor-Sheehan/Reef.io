//
//  DispenserRefillVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/31/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Foundation

class DispenserRefillVC: UIViewController {

    var basin: Int = 0 // basin is the tracker for the basin view
    @IBOutlet weak var dispenserPercent: UILabel!
    @IBOutlet weak var basinImage: UIImageView!
    @IBOutlet weak var sliderCircles: UIImageView!
    @IBOutlet weak var infoBlurb: UILabel!
    @IBOutlet weak var basinModule: UIImageView!
    @IBOutlet weak var dispenserTitle: UILabel!
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    var brain: AppBrain!
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load app brain from App Delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
            brain = appDelegate.appBrain
        }

        self.navigationController?.navigationBar.isHidden = false
        
        title = "Solution Dispenser"
        designUI()
        addGestureRecognizers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refilledBasin), name: NSNotification.Name(rawValue: "refilledBasin"), object: nil)
    
    }
    
    func addGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    func designUI(){
        let basinValues: [Int] = [brain.getBasinLevels().nutrientLvl, brain.getBasinLevels().phDownLvl, brain.getBasinLevels().phUpLvl]
        
        let percentLeft = String(Int((Float(basinValues[basin])/300.0)*100))
        
       
        if basin == 0 {
            dispenserPercent.text = percentLeft + "%"
            self.sliderCircles.image = #imageLiteral(resourceName: "Slider Circles (1)")
            self.basinImage.image = #imageLiteral(resourceName: "pH Down")
            self.infoBlurb.text = "Reef’s nutrient dispenser supplements the ecosystem with organic nutrients to boost plant growth."
            self.dispenserTitle.text = "Nutrients"
            
        }
        else if basin == 1 {
            dispenserPercent.text = percentLeft + "%"
            self.sliderCircles.image = #imageLiteral(resourceName: "Slider Circles (2)")
            self.basinImage.image = #imageLiteral(resourceName: "Nutrients")
            self.infoBlurb.text = "The pH Down Dispenser reduces the pH of the water to keep it in the ideal pH range for maximum plant growth."
            self.dispenserTitle.text = "pH Down"
            
        }
        else {
            dispenserPercent.text = percentLeft + "%"
            self.sliderCircles.image = #imageLiteral(resourceName: "Slider Circles (3)")
            self.basinImage.image = #imageLiteral(resourceName: "pH Up")
            self.infoBlurb.text = "The pH Up Dispenser raises the pH of the water to keep it in the ideal pH range for maximum plant growth."
            self.dispenserTitle.text = "pH Up"
        }
        
        self.drawCircles()
        self.animateCircle()
    }
        
        @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                    
                case UISwipeGestureRecognizer.Direction.left:
                    if(basin == 0){
                        basin = 1
                        self.designUI()
                    }
                    else if(basin == 1){
                        basin = 2
                        self.designUI()
                    }
                    
                
                case UISwipeGestureRecognizer.Direction.right:
                if(basin == 1){
                    basin = 0
                    self.designUI()
                }
                else if(basin == 2){
                    basin = 1
                    self.designUI()
                    
                }
                default:
                    break
            }
        }
    }
    

    @IBAction func refillCartridge(_ sender: UIButton) {
        self.displayAlert(title: "Refill Basin", message: "Did you refill Reef's " + dispenserTitle.text! + " basin?")
    }
    
    // If Basin was refilled, then update the UI to match
    @objc func refilledBasin() { designUI() }
    
    
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            
            if self.appDeleg.connected {
                if self.basin == 1 { self.appDeleg.sendMessage(message: "0B3") }
                else if self.basin == 2 { self.appDeleg.sendMessage(message: "0B3") }
                else {
                    self.appDeleg.sendMessage(message: "0B1")
                }
            }
            else {
                self.disconnectedAlert()
            }
        })

        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in })
        alertController.addAction(yes)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func disconnectedAlert() {
        let alert = UIAlertController(title: "Disconnected from Reef", message: "Connect to Reef and try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension DispenserRefillVC {
    func drawCircles(){
        let center = CGPoint(x: basinModule.frame.origin.x + (basinModule.frame.width*0.84), y: basinModule.frame.origin.y + (basinModule.frame.height*0.5))
        
        let startangle = CGFloat.pi
        let endangle = startangle + 2*CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 32, startAngle: startangle, endAngle: endangle, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red:0.32, green:0.69, blue:0.67, alpha:1.0).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle(){
        let basinValues: [Int] = [brain.getBasinLevels().phDownLvl,brain.getBasinLevels().nutrientLvl,brain.getBasinLevels().phUpLvl]
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = Double(basinValues[basin])/300.0
        basicAnimation.duration = 1.0
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}

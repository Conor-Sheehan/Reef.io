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

    var basin: Int = 0 // Basin is the tracker for the basin view
    let basinNames =            ["Nutrients", "pH Down", "pH Up"]
    let basinDescriptions =     ["Reef’s nutrient dispenser supplements the ecosystem with organic nutrients to boost plant growth.",
                                "The pH Down Dispenser reduces the pH of the water to keep it in the ideal pH range for maximum plant growth.",
                                "The pH Up Dispenser raises the pH of the water to keep it in the ideal pH range for maximum plant growth." ]
    let basinImages        =    [#imageLiteral(resourceName: "pH Down"),#imageLiteral(resourceName: "Nutrients"),#imageLiteral(resourceName: "pH Up")]
    let sliderCircleImages =    [#imageLiteral(resourceName: "Slider Circles1"),#imageLiteral(resourceName: "Slider Circles2"),#imageLiteral(resourceName: "Slider Circles3")]
    
    // UI ELEMENTS
    @IBOutlet weak var dispenserPercent: UILabel!
    @IBOutlet weak var basinImage: UIImageView!
    @IBOutlet weak var infoBlurb: UILabel!
    @IBOutlet weak var basinModule: UIImageView!
    @IBOutlet weak var dispenserTitle: UILabel!
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show navigation bar
        self.navigationController?.isNavigationBarHidden = false
        
        // Load app brain from App Delegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
        
        // Set notifiers for basin data being read and basins refilled
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NSNotification.Name(rawValue: "basinsRead"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refilledBasin), name: NSNotification.Name(rawValue: "refilledBasin"), object: nil)
    }
    
    // Hide navigation bar when view is seet to dissapear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
    }
    
    /// UPDATE UI BASED ON WHICH BASIN USER IS VIEWING
    @objc func updateUI() {
        
        let brain = appDeleg.appBrain!
        
        let basinValues: [Int] = [brain.getBasinLevels().nutrientLvl, brain.getBasinLevels().phDownLvl, brain.getBasinLevels().phUpLvl]
        
        let percentLeft = String(Int((Float(basinValues[basin])/70.0)*100))
        
        // Update all of the UI elements
        dispenserPercent.text = percentLeft + "%"
        basinImage.image = basinImages[basin]
        infoBlurb.text = basinDescriptions[basin]
        dispenserTitle.text = basinNames[basin]
        
        drawCircles()
        animateCircle()
    }
        

    
    /// ACTION WHEN USER TAPS ON REFILLING CARTRIDGE
    @IBAction func refillCartridge(_ sender: UIButton) {
        self.refillBasinAlert(title: "Refill Basin", message: "Did you refill Reef's " + dispenserTitle.text! + " basin?")
    }
    
    // If Basin was refilled, then update the UI to match
    @objc func refilledBasin() {
        updateUI()
        self.displayAlert(title: "Refilled Basin!", message: "Alerted Reef that you refilled the " + dispenserTitle.text! + " basin.")
    }
    
    
    func refillBasinAlert(title: String, message: String){
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { action in
            
            // if App is Connected to Reef's bluetooth, then send a refill mnessage
            if self.appDeleg.connected {
                let message = "0B" + String(self.basin+1)
                self.appDeleg.sendMessage(message: message)
            }
            else {
                self.displayAlert(title: "Disconnected from Reef", message: "Connect to Reef and try again")
            }
        })

        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in })
        alertController.addAction(yes)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


/// EXTENSION FOR ANIMATING CIRCLES
extension DispenserRefillVC {
    
    func drawCircles(){
        let center = CGPoint(x: dispenserPercent.frame.midX, y: dispenserPercent.frame.midY)
        
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
        
        let brain = appDeleg.appBrain!
        
        let basinValues: [Int] = [brain.getBasinLevels().nutrientLvl,brain.getBasinLevels().phDownLvl,brain.getBasinLevels().phUpLvl]
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = Double(basinValues[basin])/70.0
        basicAnimation.duration = 1.0
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}


// EXTENSION FOR HANDLING SWIPE GESTURES
extension DispenserRefillVC {
    
    
    /// ADD GESTURE RECOGNIZERS TO VIEW
    func addGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    /// UPDATE UI AFTER USER SWIPES
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.left:
                if basin == 0 {
                    basin = 1
                    self.updateUI()
                }
                else if basin == 1 {
                    basin = 2
                    self.updateUI()
                }
                
                
            case UISwipeGestureRecognizer.Direction.right:
                if basin == 1 {
                    basin = 0
                    self.updateUI()
                }
                else if basin == 2 {
                    basin = 1
                    self.updateUI()
                }
            default:
                break
            }
        }
    }
    
}

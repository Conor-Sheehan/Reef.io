//
//  HomeVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/17/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import UserNotifications

class HomeVC: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

    // UI ELEMENTS
    @IBOutlet weak var startGrowButton: UIButton!
    @IBOutlet weak var reefImage: UIButton!
    @IBOutlet weak var bluetoothImage: UIImageView!
    @IBOutlet weak var growStage: UILabel!
    @IBOutlet weak var percentStage: UILabel!
    @IBOutlet weak var percentText: UILabel!
    @IBOutlet weak var growStageTracker: UIButton!
    @IBOutlet weak var growTips: UILabel!
    
    // BASIN UI ELEMENTS
    @IBOutlet weak var nutrientsBar: UIProgressView!
    @IBOutlet weak var nutrientPercent: UILabel!
    @IBOutlet weak var phDownBar: UIProgressView!
    @IBOutlet weak var phDownPercent: UILabel!
    @IBOutlet weak var phUpBar: UIProgressView!
    @IBOutlet weak var phUpPercent: UILabel!
    
    private var growStages: [String] = ["Seedling", "Vegetative", "Flowering"]
    
    private var compiledData: String = ""
    
    private var percentGrowStage: Double = 0.0
    
    var appDeleg: AppDelegate!
    //var brain: AppBrain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        // Load the app delegate to access brain and bluetooth protocol
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
        }
        
        // Set notifiers for when the basin levels are read and when Reef's Bluetooth Connection State Changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayReefConnectionState), name: NSNotification.Name(rawValue: "connectionStateChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayBasinLevels), name: NSNotification.Name(rawValue: "basinsRead"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayGrowData), name: NSNotification.Name(rawValue: "growDataRead"), object: nil)
        
        
        percentStage.text = "0"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Display Reef Connection State
        displayReefConnectionState()
        // Display Grow Stage Tracker
        displayGrowStageTracker()
        //Display Basin Levels
        displayBasinLevels()
        // Display Grow Data
        displayGrowData()
        // Set display for grow tips
        displayGrowTips()
    }
    
    @objc func displayGrowData() {
        
        let brain = appDeleg.appBrain!
        
        let growProgressElements = [percentStage, growStage, percentText, growStageTracker]
        
        // Check if user's started grow
        if brain.getSettings().growStarted {
            
            for element in growProgressElements { element?.alpha = 1.0 }
            startGrowButton.alpha = 0.0
            displayGrowStatus()
        }
        else {
            for element in growProgressElements { element?.alpha = 0.0 }
            startGrowButton.alpha = 1.0
        }

    }
    
    /// Toggles the UI State Change when Reef connects/disconnects
    @objc func displayReefConnectionState() {
        // If Reef is connected, then set indicators to ON
        if appDeleg.connected { reefImage.alpha = 1.0; bluetoothImage.alpha = 1.0 }
        // Else set to OFF
        else { reefImage.alpha = 0.5; bluetoothImage.alpha = 0.0 }
    }
    
    func displayGrowStageTracker() {
        let growStage = appDeleg.appBrain.growStage
        let imageName = ["Grow Progress (1)","Grow Progress (2)","Grow Progress (3)"]
        growStageTracker.setImage(UIImage(named: imageName[growStage]), for: .normal)
    }
    
    @objc func displayBasinLevels() {
        // Basin levels stored in brain
        let basinLevels = [appDeleg.appBrain.getBasinLevels().nutrientLvl, appDeleg.appBrain.getBasinLevels().phDownLvl, appDeleg.appBrain.getBasinLevels().phUpLvl]
        let basinProgressBars = [nutrientsBar,phDownBar,phUpBar]
        let basinPercents = [nutrientPercent,phDownPercent,phUpPercent]
        
        
        // Iterate over basin levels and convert into percent text and progress bars
        for basin in 0...2 {
            let basinLvl = basinLevels[basin]
            basinProgressBars[basin]?.progress = (Float(basinLvl)/70.0)
            basinPercents[basin]?.text = String(Int((Double(basinLvl)/70.0)*100.0)) + "%"
        }
        
    }
    
    /// Segues user to proper Dispenser VC with proper basin loaded
    @IBAction func basinTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DispenserRefillVC") as! DispenserRefillVC
        vc.basin = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayGrowTips() {
        
        let growStage = appDeleg.appBrain.getGrowData().growStage
        let growStarted = appDeleg.appBrain.getSettings().growStarted
        var displayText = ""
        
        if !growStarted {
            displayText = "To get started growing with Reef, tap the button above."
        }
        else if growStage == 0 {
            displayText = "During seedling stage water your plant lightly once a day."
        }
        else if growStage == 1 {
            displayText = "During vegeatative stage you can start training your plant."
        }
        else {
            displayText = "During flowering Reef's tank will need to be refilled more often."
        }
        
        growTips.text = displayText
        
    }
    
    
    
}

// Firebase handler
extension HomeVC {
    
    /// Reads in Grow Data from brain
    func displayGrowStatus() {
        // Read data from app brain
        let currGrowStage = appDeleg.appBrain.growStage
        let currPercentStage = appDeleg.appBrain.getGrowData().percentStage
        
        drawCircles()
        
        // If percent of the grow stage has been updated
        if percentGrowStage != currPercentStage {
        
            percentGrowStage = currPercentStage
            
            // Read and display current stage of growth
            growStage.text = self.growStages[currGrowStage]
            // Animate text counting up
            countAnimation(counter: 0, total: Int(percentGrowStage*100))
            // Animate progress circle
            animateCircle()
        }
    }
    
}

// Animation Extension
extension HomeVC {
    
    
    func countAnimation(counter: Int, total: Int){
        
        let delay = 1.2/(Double(total)+1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            self.percentStage.text = String(counter)
            if(counter < total) {
                self.countAnimation(counter: counter + 1, total: total)
            }
        }
    }
    
    func drawCircles() {
        
        // Start the center of the circle to be the mid points of the percentage text
        let center = CGPoint(x: percentStage.frame.midX, y: percentStage.frame.midY)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 105, startAngle: -5*CGFloat.pi/4, endAngle: CGFloat.pi/4, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red:0.89, green:0.81, blue:0.71, alpha:1.0).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func animateCircle() {
        let brain = appDeleg.appBrain!
        
        print("Animate circle")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = brain.getGrowData().percentStage
        basicAnimation.duration = 1.2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}



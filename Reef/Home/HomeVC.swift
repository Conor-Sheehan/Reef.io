//
//  HomeVC.swift
//  Reef
//
//  Created by Conor Sheehan on 8/17/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import UserNotifications

class HomeVC: UIViewController, UIGestureRecognizerDelegate {

    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

    // GROW TRACKER UI ELEMENTS
    @IBOutlet weak var startGrowButton: UIButton!
    @IBOutlet weak var startGrowImage: UIImageView!
    @IBOutlet weak var growStage: UILabel!
    @IBOutlet weak var percentStage: UILabel!
    @IBOutlet weak var percentText: UILabel!
    @IBOutlet weak var growStageTracker: UIButton!

    // CRITICAL READOUTS UI ELEMENTS
    @IBOutlet weak var connectionState: UILabel!
    @IBOutlet weak var daylightHours: UILabel!
    @IBOutlet weak var plantHeight: UILabel!
    @IBOutlet weak var PH: UILabel!
    @IBOutlet weak var reefName: UILabel!

    // GROW TIPS UI ELEMENTS
    @IBOutlet weak var tapView: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var growTips: UILabel!
    @IBOutlet weak var upArrow: UIImageView!
    var growTipsOpen = false

    private var growStages: [String] = ["SEEDLING", "VEGETATIVE", "FLOWERING"]

    private var compiledData: String = ""

    private var percentGrowStage: Double = 0.0

    var appDeleg: AppDelegate!

    var timer = Timer()
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayReefConnectionState),
                                               name: NSNotification.Name(rawValue: "connectionStateChange"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayGrowData),
                                               name: NSNotification.Name(rawValue: "growDataRead"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidAppear(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayUserName),
                                               name: NSNotification.Name(rawValue: "userSettingsRead"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayPHValue),
                                               name: NSNotification.Name(rawValue: "phRead"),
                                               object: nil)

        // Set UI Elements to Default Values
        percentStage.text = "0"
        growTips.alpha = 0.0

        // Tap view setup
        initialLayoutTapView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self
        // allow for user interaction
        tapView.isUserInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        tapView.addGestureRecognizer(tap)

        // Set default location to 7
        UserDefaults.standard.set(2, forKey: "setupLocation")
        appDeleg.setupComplete = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Display Reef Connection State
        displayReefConnectionState()
        // Display Grow Stage Tracker
        displayGrowStageTracker()
        //Display Day Hours
        displayDayHours()
        //Display Plant Height
        displayPlantHeight()
        // Display Grow Data
        displayGrowData()
        // Set display for grow tips
        displayGrowTips()
    }

    /// When view will disappear then invalidate timer
    override func viewWillDisappear(_ animated: Bool) {
        if timer.isValid { timer.invalidate() }
    }

    /// Called when user taps the GrowTips panel
    @objc func handleTap() {
        // If the growTips Tab is not open, then animate the Tab to open
        if !growTipsOpen {
            upArrow.alpha = 0.0

            UIView.animate(withDuration: 0.25, animations: {
                self.tapView.frame = CGRect(x: self.view.frame.minX,
                                            y: self.view.frame.maxY - 150, width: self.view.frame.width, height: 150)
                self.icon.frame = CGRect(x: self.tapView.frame.midX - 12.5,
                                         y: self.tapView.frame.minY + 30, width: 25, height: 25)
                self.growTips.frame = CGRect(x: self.tapView.frame.midX - ((self.view.frame.width - 50)/2),
                                             y: self.icon.frame.maxY + 5, width: self.view.frame.width - 50, height: 60)
                self.growTips.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: { self.initialLayoutTapView() }) { (_) in
                self.upArrow.alpha = 1.0
                self.growTips.alpha = 0.0
            }
        }

        growTipsOpen = !growTipsOpen
    }

    func initialLayoutTapView() {
        tapView.frame = CGRect(x: view.frame.minX, y: view.frame.maxY - 75, width: view.frame.width, height: 150)
        icon.frame = CGRect(x: tapView.frame.midX - 12.5, y: tapView.frame.minY + 30, width: 25, height: 25)
        growTips.frame = CGRect(x: tapView.frame.midX - ((view.frame.width - 50)/2),
                                y: icon.frame.maxY + 20, width: view.frame.width - 50, height: 60)
        upArrow.frame = CGRect(x: tapView.frame.midX - 7.5, y: tapView.frame.minY + 15, width: 15, height: 15)
    }

    @objc func displayUserName() {
    }

    @objc func displayPHValue() {
       // PH.text = appDeleg.appBrain.getGrowData().currentPH
    }

    @objc func displayGrowData() {

        //let brain = appDeleg.appBrain!

        //let growProgressElements = [percentStage, growStage, percentText, growStageTracker]

        // Check if user's started grow
//        if brain.getSettings().growStarted {
//
//            for element in growProgressElements { element?.alpha = 1.0 }
//            startGrowButton.alpha = 0.0
//            startGrowImage.alpha = 0.0
//            displayGrowStatus()
//        }
//        else {
//            for element in growProgressElements { element?.alpha = 0.0 }
//            startGrowButton.alpha = 1.0
//            startGrowImage.alpha = 1.0
//        }

    }

    /// Toggles the UI State Change when Reef connects/disconnects
    @objc func displayReefConnectionState() {
        print("Displaying reef connection state")
        // CHANGE TO SOME OTHER RELEVANT UI/UX
    }

    func displayDayHours() {
//        let growStage = appDeleg.appBrain.growStage
//        let growStarted = appDeleg.appBrain.getSettings().growStarted

        // If user has not statrted grow, then set day hours to 0
//        if !growStarted { daylightHours.text = "0 Hours" }
//        // Else if user's grow stage is not flowering then set to 18 hours
//        else if growStage != 2 { daylightHours.text = "18 Hours" }
//        // Else set to 12 Hours
//        else { daylightHours.text = "12 Hours" }
    }

    func displayPlantHeight() {
//        plantHeight.text = String(appDeleg.appBrain.getGrowData().currentPlantHeight)
//            + " in."
    }

    func displayGrowStageTracker() {
//        let growStage = appDeleg.appBrain.growStage
//        let imageName = ["Grow Stage (1)","Grow Stage (2)","Grow Stage (3)"]
//        growStageTracker.setImage(UIImage(named: imageName[growStage]), for: .normal)
    }

    func displayGrowTips() {

//        let growStage = appDeleg.appBrain.getGrowData().growStage
//        let growStarted = appDeleg.appBrain.getSettings().growStarted
//        var displayText = ""
//        
//        if !growStarted {
//            displayText = "To get started growing with Reef, tap the button above."
//        }
//        else if growStage == 0 {
//            displayText = "During seedling, water your sprout lightly once per day."
//        }
//        else if growStage == 1 {
//            displayText = "During vegeatative stage you can start training your plant."
//        }
//        else {
//            displayText = "During flowering Reef's tank will need to be refilled more often."
//        }
//
//        growTips.text = displayText

    }

}

// Animation Extension
extension HomeVC {

    /// Reads in Grow Data from brain
    func displayGrowStatus() {
        // Read data from app brain
//        let currGrowStage = appDeleg.appBrain.growStage
//        let currPercentStage = appDeleg.appBrain.getGrowData().percentStage
//
//        // If percent of the grow stage has been updated
//        if percentGrowStage != currPercentStage {
//
//            drawCircles()
//
//            percentGrowStage = currPercentStage
//
//            // Read and display current stage of growth
//            growStage.text = self.growStages[currGrowStage]
//            // Animate text counting up
//            countAnimation(counter: 0, total: Int(percentGrowStage*100))
//            // Animate progress circle
//            animateCircle()
//        }
    }

    func countAnimation(counter: Int, total: Int) {

        let delay = 1.2/(Double(total)+1.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.percentStage.text = String(counter)
            if counter < total {
                self.countAnimation(counter: counter + 1, total: total)
            }
        }
    }

    func drawCircles() {

        // Start the center of the circle to be the mid points of the percentage text
        let center = CGPoint(x: percentStage.frame.midX, y: percentStage.frame.midY)

        let circularPath = UIBezierPath(arcCenter: center, radius: 100,
                                        startAngle: -5*CGFloat.pi/4, endAngle: CGFloat.pi/4, clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0).cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 0.57, green: 0.67, blue: 0.60, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0

        view.layer.addSublayer(shapeLayer)
    }

    func animateCircle() {
//        let brain = appDeleg.appBrain!
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = brain.getGrowData().percentStage
//        basicAnimation.duration = 1.2
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "Circular")
    }
}

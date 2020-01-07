//
//  DeveloperModeVC.swift
//  Reef
//
//  Created by Conor Sheehan on 9/20/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit

class DeveloperModeVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var responseString: UILabel!
    @IBOutlet weak var stringSent: UILabel!
    var responseMessages: String = ""
    @IBOutlet weak var textField: UITextField!
    
    var brain: AppBrain!
    var appDeleg: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDeleg = appDelegate
            brain = appDelegate.appBrain
        }
        
        textField.delegate = self
        
        // Look out for new messages from bluetooth
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewMessage), name: NSNotification.Name(rawValue: "receivedNewMessage"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func receivedNewMessage() {
        print("RECEIVED MESSAGE IN DEVELOPER MODE")
        self.responseMessages += appDeleg.getMostRecentMessage() + "\n"
        responseString.text = responseMessages
    }

    
    @IBAction func checkInWithReef(_ sender: UIButton) {
        self.responseMessages = ""
        
        appDeleg.sendMessage(message: appDeleg.getCurrentCheckInMessage())
        stringSent.text = "Check In"
    }
    
    @IBAction func setPumpsToOn(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0A1")
        stringSent.text = "Turn Pumps On"
    }
    
    @IBAction func turnPumpsOff(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0A0")
        stringSent.text = "Turn Pumps Off"
    }
    
    @IBAction func setDayHours(_ sender: UIButton) {
        guard let hours = textField.text else { return }
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0H" + hours)
        stringSent.text = "Set day hours to " + hours
    }
    
    @IBAction func fireEveryPump(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0T1")
        stringSent.text = "Fire every pump"
    }
    
    @IBAction func getSensorValues(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0T2")
        stringSent.text = "Get Sensor Values"
    }
    
    @IBAction func fireNutrients(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0F1")
        stringSent.text = "Fire Nutrients"
    }
    @IBAction func firePHUp(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0F3")
        stringSent.text = "Fire PH Up"
    }
    @IBAction func firePHDown(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0F2")
        stringSent.text = "Fire PH Down"
    }
    
    @IBAction func getPlantHeightData(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0D2")
        stringSent.text = "Get Plant Height Data"
    }
    
    @IBAction func getPHData(_ sender: UIButton) {
        self.responseMessages = ""
        appDeleg.sendMessage(message: "0D1")
        stringSent.text = "Get PH Data"
    }
    @IBAction func customMessage(_ sender: UIButton) {
        guard let msg = textField.text else { return }
        self.responseMessages = ""
        appDeleg.sendMessage(message: msg)
        stringSent.text = "Custom message " + msg
    }
}



extension DeveloperModeVC {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//
//  SignUpVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Hero
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    var clickerCounter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        email.delegate = self
        password.delegate = self
        
        self.isHeroEnabled = true
        
        //Recognize swipe down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        // Recognizes when keyboard will show and hide for entering username and password
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }

    
    
    @IBOutlet weak var SignUp: UIButton!
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        guard let name = name.text else { return }
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        
        // Authorize user in Firebase
        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            
            if error == nil && user != nil {
                print("User created")
                // Store username and password in deep storage
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(name, forKey: "name")
                
                self.alertUser(title: "Created Account!", message: "Welcome to the Infinitry Community.")

            }
                // Create error case if user is not properly entered to Firebase
            else{
                
                self.alertUser(title: "Invalid Credentials", message: (error?.localizedDescription)!)
            }
        }
    }
    
    func alertUser(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) -> Void in
            if(title == "Created Account!"){
                let InitialSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "InitialSetup") as! InitialSetup
                InitialSetupVC.isHeroEnabled = true
                InitialSetupVC.heroModalAnimationType = .fade
                self.hero_replaceViewController(with: InitialSetupVC)
            }
        })
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Show keyboard")
        if(clickerCounter != 1){
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= (keyboardSize.height - 40)
                }
            }
        }
            
        else{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= (keyboardSize.height - 110)
                }
            }
            clickerCounter += 1
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.down:
                self.view.endEditing(true)
                print("Swiped left")
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

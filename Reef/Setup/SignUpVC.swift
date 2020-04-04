//
//  SignUpVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var reefID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var HeadlineText: UILabel!
    
    let buttonWidth: CGFloat = 220
    let buttonHeight: CGFloat = 44
    
    
    /// This method is called after the view controller has loaded its view hierarchy into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates of textfields to current VC
        email.delegate = self
        reefID.delegate = self
        password.delegate = self
        name.delegate = self
        
        // Add observers and recognizers to VC
        addKeyboardObservers()
        addGestureRecognizers()

        // Move the sign up button to the initial location
        SignUp.frame = CGRect(x: self.view.frame.midX - 110, y:  self.view.frame.midY*1.7, width: buttonWidth, height: buttonHeight)
        
    }

    

    /// ACTION TRIGGERED when user taps the sign up button
    @IBAction func SignUp(_ sender: UIButton) {
        
        // Retrieve the user-input data from the Text Fields
        guard let name = name.text else { return }
        guard let reefId = reefID.text else { return }
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        
        // Authorize user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            // If Firebase does not return an error message when creating the user
            if error == nil && user != nil {
                print("User created")
                
                // Initialize App Brain and store first name in firebase
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    
                    appDelegate.initializeAppBrain()                    // Initialize App Brain Local Data Storage
                    appDelegate.activateNotifications()
                    appDelegate.activateRemoteNotifications()
                    appDelegate.appBrain.use
                    appDelegate.appBrain.storeReefID(reefID: reefId)    // Store user's Reef ID in Firebase
                    appDelegate.appBrain.storeMessagingToken(FCMtoken: appDelegate.FCMtoken) // Store messaging tokeen
                }
                
                // Alert user that account was successfully created
                self.alertUser(title: "Created Account!", message: "Welcome to the Reef.")
            }
            
            // Create error case if user is not properly entered to Firebase
            else { self.alertUser(title: "Invalid Credentials", message: (error?.localizedDescription)!) }
        }
    }
    
    /// Alert user if their sign up attempt was valid or invalid
    func alertUser(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
            if title == "Created Account!" {
                self.view.endEditing(true)
                self.performSegue(withIdentifier: "segueToConnect", sender: self)
            }
        })
        
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    /// CALLED WHEN KEYBOARD IS PROMPTED TO APPEAR ON THE SCREEN
    @objc func keyboardWillShow(notification: NSNotification) {
            
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
            
                SignUp.frame = CGRect(x: self.view.frame.midX - 110, y:  password.frame.maxY + 30, width: buttonWidth, height: buttonHeight)
                
                // if the keyboard is covering up the password text entry, then move the frame
                if (self.view.frame.maxY - (keyboardSize.height)) <  password.frame.maxY + 70 {
                    let distanceToMoveFrame = password.frame.maxY - (self.view.frame.maxY - (keyboardSize.height)) + 75
                    self.view.frame.origin.y -= distanceToMoveFrame
                }
            }
        }
    }
    
    /// CALLED WHEN KEYBOARD IS DISMISSED FROM SCREEN
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        SignUp.frame = CGRect(x: self.view.frame.midX - 110, y:  self.view.frame.midY*1.7, width: buttonWidth, height: buttonHeight)
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.down:
                self.view.endEditing(true)
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    /// GESTURE RECOGNIZES USER SWIPE DOWN TO DISMISS KEYBOARD
    func addGestureRecognizers() {
        //Recognize swipe down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    /// ADDS OBSERVERS TO DETECT WHEN KEYBOARD SHOULD APPEAR AND BE DISMISSED
    func addKeyboardObservers() {
        // Recognizes when keyboard will show and hide for entering username and password
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }



}

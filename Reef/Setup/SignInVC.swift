//
//  LogInVC.swift
//  Reef
//
//  Created by Conor Sheehan on 6/25/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emailInvalidLabel: UILabel!
  @IBOutlet weak var passwordInvalidLabel: UILabel!
  
  let textFieldBackground = UIImage(named: "TextField")
  let invalidTextfieldBackground = UIImage(named: "TextField-Invalid Input")
  let generator = UINotificationFeedbackGenerator()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
    emailTextField.disableAutoFill()
    passwordTextField.disableAutoFill()
  
    activityIndicator.isHidden = true
    emailInvalidLabel.isHidden = true
    passwordInvalidLabel.isHidden = true
    
    // Add observers and recognizers to VC
    addKeyboardObservers()
    addGestureRecognizers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func checkIfTextFieldEmpty(email: String, password: String) -> Bool {
    
    if email == "" {
     emailInvalidLabel.text = "Please enter a valid email."
     emailInvalidLabel.isHidden = false
     emailTextField.background = invalidTextfieldBackground
     return true
    }
    else if password == "" {
     passwordInvalidLabel.text = "Please enter your password."
     passwordInvalidLabel.isHidden = false
     passwordTextField.background = invalidTextfieldBackground
     return true
    }
    
    return false
  }
  
  func startActivityIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    signInButton.isEnabled = false
    signInButton.setTitle("", for: .normal)
  }
  
  func stopActiviityIndicator() {
    activityIndicator.isHidden = true
    activityIndicator.startAnimating()
    signInButton.isEnabled = true
    signInButton.setTitle("Sign In", for: .normal)
  }
  
  func displayAuthFailedError(error: NSError) {
    switch AuthErrorCode(rawValue: error.code) {
    case .wrongPassword:
      showInvalidErrorMessage(textField: passwordTextField, invalidLabel: passwordInvalidLabel, message: "Incorrect password. Please try again")
      return
    case .invalidEmail:
      showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel, message: "Please enter a valid email.")
      return
    default:
      alertUser(title: "Invalid Credentials", message: error.localizedDescription)
      return
    }
  }
  
  func showInvalidErrorMessage(textField: UITextField, invalidLabel: UILabel, message: String) {
    textField.background = invalidTextfieldBackground
    invalidLabel.isHidden = false
    invalidLabel.text = message
  }
  
  
  @IBAction func signIn(_ sender: Any) {
    
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    // Check if text fields are empty, display error message and don't authorize
    if checkIfTextFieldEmpty(email: email, password: password) { return }
    
    // Start activity indicator before attempting to authorizee user
    startActivityIndicator()
    
    
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      
      // Stop activity indicator after completing authorization
      self?.stopActiviityIndicator()
      
      // If user was not successfully signed in, Display error messages
      if let error = error as NSError? {
        self?.generator.notificationOccurred(.error)
        self?.displayAuthFailedError(error: error)
      }
      
      // Else, if authorization was successful
      else {
        self?.generator.notificationOccurred(.success)
        self?.alertUser(title: "Sign In Successful", message: "Welcome back to Reef!")
      }
      
    }
  }
  
  
  func alertUser(title: String, message: String){
      let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
          if title == "Sign In Successful" {
              self.view.endEditing(true)
              //self.performSegue(withIdentifier: "segueToConnect", sender: self)
          }
      })
      
      alertVC.addAction(action)
      self.present(alertVC, animated: true, completion: nil)
  }
  


}

// Extension for handling Keyboard and Gesture Events
extension SignInVC {
  
  /// CALLED WHEN KEYBOARD IS PROMPTED TO APPEAR ON THE SCREEN
   @objc func keyboardWillShow(notification: NSNotification) {
    
    print("Keyboard will show")
           
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           if self.view.frame.origin.y == 0 {
             
             let keyboardHeight = keyboardSize.height
             let screenHeight = self.view.frame.maxY
             let signInButtonYValue = self.passwordTextField.frame.maxY
               
               // if the keyboard is covering up the password text entry, then move the frame
             if ( screenHeight - keyboardHeight <  signInButtonYValue ) {
               
               let distanceToMoveFrame = signInButtonYValue - (screenHeight - keyboardHeight) + 40
               self.view.frame.origin.y -= distanceToMoveFrame
             }
           }
       }
   }
   
   /// CALLED WHEN KEYBOARD IS DISMISSED FROM SCREEN
   @objc func keyboardWillHide(notification: NSNotification) {
       self.view.frame.origin.y = 0
   }
   
   
   @objc func respondToGesture(gesture: UIGestureRecognizer) {
      self.view.endEditing(true)
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {

     if textField == emailTextField { passwordTextField.becomeFirstResponder() }
     else {
      // Attempt to Log in
      signIn(self)
      self.view.endEditing(true)
    }
       
       return true
   }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch textField {
    case emailTextField:
      emailTextField.background = textFieldBackground
      emailInvalidLabel.isHidden = true
    default:
      passwordTextField.background = textFieldBackground
      passwordInvalidLabel.isHidden = true
    }
    
    return true
  }
  /// GESTURE RECOGNIZES USER SWIPE DOWN TO DISMISS KEYBOARD
    func addGestureRecognizers() {
        //Recognize swipe down
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.respondToGesture) )
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /// ADDS OBSERVERS TO DETECT WHEN KEYBOARD SHOULD APPEAR AND BE DISMISSED
    func addKeyboardObservers() {
        // Recognizes when keyboard will show and hide for entering username and password
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
     switch textField {
     case emailTextField:
       guard let email = emailTextField.text else { return }
       if !isValidEmail(email) { showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel, message: "Please enter a valid email address") }
       
     default:
       return
       }
   }
  
  
  
  func isValidEmail(_ email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

       let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailPred.evaluate(with: email)
   }
}

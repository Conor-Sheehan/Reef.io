//
//  ForgotPasswordVC.swift
//  Reef
//
//  Created by Conor Sheehan on 6/26/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var resetPasswordButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var invalidTextLabel: UILabel!
  
  let generator = UINotificationFeedbackGenerator()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    emailTextField.delegate = self
    
    invalidTextLabel.isHidden = true
    activityIndicator.isHidden = true
    
    // Add observers and recognizers to VC
   addKeyboardObservers()
   addGestureRecognizers()
  }
  deinit {
     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
     NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
   }
  
  func startActivityIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    resetPasswordButton.isEnabled = false
    resetPasswordButton.setTitle("", for: .normal)
  }
  
  func stopActivityIndicator() {
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
    resetPasswordButton.isEnabled = true
    resetPasswordButton.setTitle("Reset Password", for: .normal)
  }
  
   func displayAuthFailedError(error: NSError) {
    switch AuthErrorCode(rawValue: error.code) {
    case .userNotFound:
      self.invalidTextLabel.text = "Email not found. Please try again."
      self.invalidTextLabel.isHidden = false
      return
    case .invalidEmail:
      self.invalidTextLabel.text = "Please enter a valid email address"
      self.invalidTextLabel.isHidden = false
      return
    default:
      print(error.localizedDescription)
      self.alertUser(title: "Attempt failed", message: error.localizedDescription)
      return
    }

  }
  
    
  @IBAction func resetPassword(_ sender: Any) {
    
    guard let email = emailTextField.text else { return }
    
    // If email field is empty, fill in placeholder text with alert message
    if email == "" {
      invalidTextLabel.text = "Please enter a valid email address"
      invalidTextLabel.isHidden = false
      emailTextField.background = UIImage(named: "TextField-Invalid Input")
      return
    }
    
    startActivityIndicator()
    
    // Else, attempt to authorize the password reset email
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      
      self.stopActivityIndicator()
      
      // If firebase returned an Error, when trying to authorize user
      if let error = error as NSError? {
        self.generator.notificationOccurred(.error)
        self.emailTextField.background = UIImage(named: "TextField-Invalid Input")
        self.displayAuthFailedError(error: error)
      }
      
      else {
        self.generator.notificationOccurred(.success)
        self.emailTextField.background = UIImage(named: "TextField")
        self.invalidTextLabel.isHidden = true
        self.alertUser(title: "Email Sent Successfully", message: "Reset password link was sent to the email entered above.")
      }
    }
    
    
  }
  
  func alertUser(title: String, message: String){
      let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
          if title == "Email Sent Successfully" {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
          }
      })
      
      alertVC.addAction(action)
      self.present(alertVC, animated: true, completion: nil)
  }
  
  
}


// Extension for handling keyboard and gesture interactions with textfields
extension ForgotPasswordVC {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    self.emailTextField.background = UIImage(named: "TextField")
    self.invalidTextLabel.isHidden = true
    return true
  }
  
  
  
  /// CALLED WHEN KEYBOARD IS PROMPTED TO APPEAR ON THE SCREEN
   @objc func keyboardWillShow(notification: NSNotification) {
           
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
         if self.view.frame.origin.y == 0 {
           
           let keyboardHeight = keyboardSize.height
           let screenHeight = self.view.frame.maxY
           let resetButtonYValue = self.emailTextField.frame.maxY
             
             // if the keyboard is covering up the password text entry, then move the frame
           if ( screenHeight - keyboardHeight <  resetButtonYValue ) {
             
             let distanceToMoveFrame = resetButtonYValue - (screenHeight - keyboardHeight) + 40
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
      self.view.endEditing(true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
}

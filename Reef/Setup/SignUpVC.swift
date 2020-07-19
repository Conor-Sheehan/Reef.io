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

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailInvalidLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordInvalidLabel: UILabel!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var confirmInvalidLabel: UILabel!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  let textFieldBackground = UIImage(named: "TextField")
  let invalidTextfieldBackground = UIImage(named: "TextField-Invalid Input")
  let generator = UINotificationFeedbackGenerator()

  var keyboardShowing = false

    /// This method is called after the view controller has loaded its view hierarchy into memory
    override func viewDidLoad() {

      super.viewDidLoad()

      // Set delegates of textfields to current VC
      emailTextField.delegate = self
      passwordTextField.delegate = self
      confirmPasswordTextField.delegate = self
      emailTextField.disableAutoFill()
      passwordTextField.disableAutoFill()
      confirmPasswordTextField.disableAutoFill()
      activityIndicator.isHidden = true
      passwordInvalidLabel.isHidden = true
      emailInvalidLabel.isHidden = true
      confirmInvalidLabel.isHidden = true

      addKeyboardObservers()
      addGestureRecognizers()
    }

  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  func showInvalidErrorMessage(textField: UITextField, invalidLabel: UILabel, message: String) {
    textField.background = invalidTextfieldBackground
    invalidLabel.isHidden = false
    invalidLabel.text = message
  }

  func checkTextFields(email: String, password: String, confirmPassword: String) -> Bool {

    if email == "" {
      showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel,
                              message: "Please enter a valid email")
      return false
    } else if password == "" {
      showInvalidErrorMessage(textField: passwordTextField, invalidLabel: passwordInvalidLabel,
                              message: "Please enter a valid password")
      return false
    } else if confirmPassword == "" {
      showInvalidErrorMessage(textField: confirmPasswordTextField, invalidLabel: confirmInvalidLabel,
                              message: "Please confirm your password")
      return false
    }

    // Verify that the password and confirmed password are the same strings
    else if password != confirmPassword {
      showInvalidErrorMessage(textField: confirmPasswordTextField, invalidLabel: confirmInvalidLabel,
                              message: "Passwords don't match. Try again.")
      return false
    }
    return true
  }

  func startActivityIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    signUpButton.isEnabled = false
    signUpButton.setTitle("", for: .normal)
  }

  func stopActiviityIndicator() {
    activityIndicator.isHidden = true
    activityIndicator.startAnimating()
    signUpButton.isEnabled = true
    signUpButton.setTitle("Sign Up", for: .normal)
  }

  func displayAuthFailedError(error: NSError) {
    switch AuthErrorCode(rawValue: error.code) {
    case .emailAlreadyInUse:
     emailTextField.becomeFirstResponder()
     showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel,
                             message: "Email already taken. Try again.")
      return
    case .invalidEmail:
     emailTextField.becomeFirstResponder()
     showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel,
                             message: "Please enter a valid email address.")
     return
    case .weakPassword:
     self.passwordTextField.becomeFirstResponder()
     showInvalidErrorMessage(textField: passwordTextField, invalidLabel: passwordInvalidLabel,
                             message: "Invalid password. Must be at least 6 characters")
     return
    default:
     self.alertUser(title: "Invalid Credentials", message: (error.localizedDescription))
     return
    }
  }

    /// ACTION TRIGGERED when user taps the sign up button
    @IBAction func signUp(_ sender: Any) {

      // Retrieve the user-input data from the Text Fields
      guard let email = emailTextField.text else { return }
      guard let password = passwordTextField.text else { return }
      guard let confirmPassword = confirmPasswordTextField.text else { return }

      if !checkTextFields(email: email, password: password, confirmPassword: confirmPassword) { return }

      // Start activity indicator before authorizing new user
      startActivityIndicator()

        // Authorize user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { _, error in

          self.stopActiviityIndicator()

          // If authorization failed, display the error
          if let error = error as NSError? {
            self.displayAuthFailedError(error: error)
            self.generator.notificationOccurred(.error)
          }

            // If Firebase does not return an error message when creating the user
           else {

              // Initialize App Brain and store first name in firebase
              if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.initializeAppBrain()
              }

              // Alert user that account was successfully created
              self.generator.notificationOccurred(.success)
              self.alertUser(title: "Created Account!", message: "Welcome to the Reef.")
            }
        }
    }

    /// Alert user if their sign up attempt was valid or invalid
    func alertUser(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction) -> Void in
            if title == "Created Account!" {
                self.view.endEditing(true)
                self.performSegue(withIdentifier: "segueToSetup", sender: self)
            }
        })

        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }

}

// Keyboard and Gesture Handling Extension for TextFields
extension SignUpVC {

  /// CALLED WHEN KEYBOARD IS PROMPTED TO APPEAR ON THE SCREEN
  @objc func keyboardWillShow(notification: NSNotification) {

    print("Keyboard will show")

      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

        if !keyboardShowing {
          keyboardShowing = true

          let keyboardHeight = keyboardSize.height
          let screenHeight = self.view.frame.maxY
          let signUpButtonYValue = self.confirmPasswordTextField.frame.maxY

          // if the keyboard is covering up the password text entry, then move the frame
          if screenHeight - keyboardHeight <  signUpButtonYValue {

            let distanceToMoveFrame = signUpButtonYValue - (screenHeight - keyboardHeight) + 40
            self.view.frame.origin.y -= distanceToMoveFrame

          }
        }
    }
  }

  /// CALLED WHEN KEYBOARD IS DISMISSED FROM SCREEN
  @objc func keyboardWillHide(notification: NSNotification) {
    keyboardShowing = false
    self.view.frame.origin.y = 0
  }

  @objc func respondToGesture(gesture: UIGestureRecognizer) {
    self.view.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    switch textField {
    case emailTextField:
      passwordTextField.becomeFirstResponder()
    case passwordTextField:
      confirmPasswordTextField.becomeFirstResponder()
    default:
      signUp(self)
      self.view.endEditing(true)
    }

      return false
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
      NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    switch textField {
    case emailTextField:
      emailTextField.background = textFieldBackground
      emailInvalidLabel.isHidden = true

    case passwordTextField:
      passwordTextField.background = textFieldBackground
      passwordInvalidLabel.isHidden = true
    default:
      confirmPasswordTextField.background = textFieldBackground
      confirmInvalidLabel.isHidden = true
    }

    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
    case emailTextField:
      guard let email = emailTextField.text else { return }
      if !isValidEmail(email) {
        showInvalidErrorMessage(textField: emailTextField, invalidLabel: emailInvalidLabel,
                                message: "Please enter a valid email address") }

    case passwordTextField:
      guard let password = passwordTextField.text else { return }
      if password.count < 6 {
        showInvalidErrorMessage(textField: passwordTextField, invalidLabel: passwordInvalidLabel,
                                message: "Invalid password. Must be at least 6 characters") }
    default:
      guard let password = passwordTextField.text else { return }
      guard let confirmPassword = confirmPasswordTextField.text else { return }
      if password != confirmPassword {
        showInvalidErrorMessage(textField: confirmPasswordTextField, invalidLabel: confirmInvalidLabel,
                                message: "Passwords don't match. Try again.")
      }
    }
  }

  func isValidEmail(_ email: String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

      let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      return emailPred.evaluate(with: email)
  }

}

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

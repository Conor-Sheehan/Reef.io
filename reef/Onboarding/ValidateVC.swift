//
//  ValidateVC.swift
//  Reef
//
//  Created by Conor Sheehan on 7/10/20.
//  Copyright © 2020 Infinitry. All rights reserved.
//

import UIKit

class ValidateVC: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var reefIDTextField: UITextField!
  @IBOutlet weak var validateButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var invalidTextLabel: UILabel!

  let generator = UINotificationFeedbackGenerator()
  let textFieldBackground = UIImage(named: "TextField")
  let invalidTextfieldBackground = UIImage(named: "TextField-Invalid Input")

  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator.isHidden = true
    invalidTextLabel.isHidden = true

    reefIDTextField.delegate = self
    addKeyboardObservers()
    addGestureRecognizers()
  }

  @IBAction func goBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  func startActivityIndicator() {
    validateButton.isEnabled = false
    validateButton.setTitle("", for: .normal)
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }

  func stopActivityIndicator() {
    self.activityIndicator.isHidden = true
    self.activityIndicator.stopAnimating()
    self.validateButton.isEnabled = true
    self.validateButton.setTitle("Validate ID", for: .normal)
  }

  func showInvalidErrorMessage(message: String) {
    reefIDTextField.background = invalidTextfieldBackground
    invalidTextLabel.isHidden = false
    invalidTextLabel.text = message
  }

  @IBAction func validateID(_ sender: Any) {

    guard let reefID = reefIDTextField.text else { return }

    if reefID == "" {
      showInvalidErrorMessage(message: "Enter a valid Reef ID")
      return
    }

    // Start activity indicator while checking DB
    startActivityIndicator()

    // Check in Firebase Database if user's ID has been registered by the Reef Team
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

      // Validate reef ID in firebasee database
      appDelegate.appBrain.validateReefID(with: reefID, completion: { isValid in
        print("Successfully validated ReefID from VC with result: ", isValid)

        self.stopActivityIndicator()

        if !isValid {
          self.generator.notificationOccurred(.error)
          self.showInvalidErrorMessage(message: "Invalid Reef ID. Please try again.")
        } else {
          self.generator.notificationOccurred(.success)
          self.performSegue(withIdentifier: "segueToNotificationVC", sender: self)
        }

      })
    }

  }

}

// Keyboard and Gesture Handling Extension
extension ValidateVC {

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {

    reefIDTextField.background = UIImage(named: "TextField")
    invalidTextLabel.isHidden = true

    return true
  }

  @objc func keyboardWillShow(notification: NSNotification) {

     print("Keyboard will show")

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
          as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {

              let keyboardHeight = keyboardSize.height
              let screenHeight = self.view.frame.maxY
              let signInButtonYValue = self.reefIDTextField.frame.maxY

                // if the keyboard is covering up the password text entry, then move the frame
              if  screenHeight - keyboardHeight <  signInButtonYValue {

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

      self.view.endEditing(true)
      validateID(self)
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
      NotificationCenter.default.addObserver(self, selector: #selector(ValidateVC.keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(ValidateVC.keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification, object: nil)
  }

}

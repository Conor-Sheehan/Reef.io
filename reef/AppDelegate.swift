//
//  AppDelegate.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    // Track where user is in Setup Process
    var setupLocation: Int = 0

    // Data Model
    var appBrain: AppBrain!
    var FCMtoken: String = ""

    var window: UIWindow?

    let content = UNMutableNotificationContent()

    var currApplication: UIApplication!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
      launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      FirebaseApp.configure()

      Messaging.messaging().delegate = self

      currApplication = application

      // CHECK WHERE USER IS IN SETUP PROCESS (1-8)
      setupLocation = UserDefaults.standard.integer(forKey: "setupLocation")
      setupLocation = 2

      // Else if user has already signed up with Reef Community
      if setupLocation >= 1 {
        // Initialize App Brain
        initializeAppBrain()
        activateRemoteNotifications(completion: { _ in
          print("Access granted")
        })
     }
      
      // FOR TESTING PURPOSES ONLY
      window?.rootViewController = initialViewController(setupLocation: setupLocation)

      return true
    }

    func initializeAppBrain() { appBrain = AppBrain(); appBrain.initialize() }

    /// Returns the first ViewController in the User's UX based on setup Compleetion
    ///
    /// - Parameter setupLocation: Integer representing the step within the setup that the user occupies
    private func initialViewController(setupLocation: Int) -> UIViewController {
        switch setupLocation {
        case 0:
          return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
        case 1:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupProcess")
        case 2:
            return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        default:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
        }

    }

  func activateRemoteNotifications(completion: @escaping (_ granted: Bool) -> Void) {

      print("Activating Remote Notifications")

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in

              completion(granted)
          })

        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          currApplication.registerUserNotificationSettings(settings)
        }

        currApplication.registerForRemoteNotifications()
    }

    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

      let dataDict: [String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      FCMtoken = fcmToken
      
      appBrain?.setFCMToken(token: fcmToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entering Background State")
    }

    /// Called as part of the transition from the background to the active state;
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // called when user interacts with notification (app not running in foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {

        // do something with the notification
        print(response.notification.request.content.userInfo)

        // the docs say you should execute this asap
        return completionHandler()
    }

    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {

        // show alert while app is running in foreground
        return completionHandler(UNNotificationPresentationOptions.alert)
    }

    func instantNotification(notificationTitle: String, notifcationBody: String) {

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        //creating the notification content
        print("Adding Notification")
        let content = UNMutableNotificationContent()

        //adding title, subtitle, body and badge
        content.title = notificationTitle
        content.body = notifcationBody
        content.badge = 1

        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        //getting the notification request
        let request = UNNotificationRequest(identifier: "Reef.connected2", content: content, trigger: trigger)

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

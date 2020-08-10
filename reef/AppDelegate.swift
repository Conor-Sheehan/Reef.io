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

    var appIsInBackground = false

    // Track where user is in Setup Process
    var setupLocation: Int = 0
    var setupComplete: Bool = false

    // Data Model
    var appBrain: AppBrain!
    var FCMtoken: String = ""

    var window: UIWindow?

    let content = UNMutableNotificationContent()

    var currApplication: UIApplication!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

      Messaging.messaging().delegate = self

      currApplication = application

      UIApplication.shared.applicationIconBadgeNumber = 0

      // CHECK WHERE USER IS IN SETUP PROCESS (1-8)
      setupLocation = UserDefaults.standard.integer(forKey: "setupLocation")
      setupLocation = 2

      print("SETUP LOCATION", setupLocation)

      // Else if user has already signed up with Reef Community
      if setupLocation >= 1 {
          // Initialize App Brain
          initializeAppBrain()
          activateRemoteNotifications(completion: { _ in
            print("Access granted")
          })
     }
      if setupLocation == 2 {
          setupComplete = true

      }

      //appBrain.reefSettings.

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
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setupNavigation")
        case 2:
            return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC")
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
        print("DEVICE TOKEN", deviceToken)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        FCMtoken = fcmToken

        if let brain = appBrain {
            // If necessary send token to application server.
          brain.setFCMToken(token: fcmToken)
        }
    }

    func application(_ application: UIApplication,
                shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
       // Save the current app version to the archive.
       coder.encode(11.0, forKey: "MyAppVersion")

       // Always save state information.
       return true
    }

    func application(_ application: UIApplication,
                shouldRestoreApplicationState coder: NSCoder) -> Bool {
       // Restore the state only if the app version matches.
       let version = coder.decodeFloat(forKey: "MyAppVersion")

       if version == 11.0 {
        print("RESTORING APPLICATION STATE")
          return true
       }

       // Do not restore from old data.
       return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entering Background State")
    }

    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
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

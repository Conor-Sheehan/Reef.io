//
//  AppDelegate.swift
//  Reef
//
//  Created by Conor Sheehan on 7/25/18.
//  Copyright © 2018 Infinitry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    // Bluetooth variables and constants
    var connectionController: CBCentralManager!
    var reefBluetooth: CBPeripheral!
    var writeType: CBCharacteristicWriteType = .withResponse
    let serviceUUIDForScanning: [CBUUID] = [CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")]
    var writeCharacteristic: CBCharacteristic!
    let UuidCharacteristic = "0000ffe1-0000-1000-8000-00805f9b34fb"
    var bluetoothCounter: Int = 1
    var connected: Bool = false     // connected is True if the Reef bluetooth is connected, False if not currently connected
    var stayConnected: Bool = false // stayConnected is True when app is in foreground and prevents the bluetooth from disconnecting automatically,  False when in background
    var lastCommunication: Date?    // lastCommunication tracks the last time that Reef and the app communicated
    var noResponse: Bool = false    // If app sent message, but didn't receive a response, then restart connection
    var mostRecentMessage: String = ""
    var sentMessage: String = ""
    var correctResponse: Bool = false
    
    var appIsInBackground = false
    
    // Track where user is in Setup Process
    var setupLocation: Int = 0
    var setupComplete: Bool = false
    
    // Data Model
    var appBrain: AppBrain!

    var window: UIWindow?
    
    let content = UNMutableNotificationContent()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
      
      Messaging.messaging().delegate = self
        
      // Set interval to fetch new data in background
      application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
      
      
      // CHECK WHERE USER IS IN SETUP PROCESS (1-8)
      setupLocation = UserDefaults.standard.integer(forKey: "setupLocation")
      
      print("SETUP LOCATION", setupLocation)
      
      // If user has already established connection with Reef, then start bluetooth
      if setupLocation > 1 { startBluetoothConnection() }
      // Else if user has already signed up with Reef Community
      if setupLocation > 2 {
        // Initialize App Brain
        initializeAppBrain()
        
        // Load FCM Token
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            self.appBrain.setFCMToken(token: result.token)
          }
        }
     }
      if setupLocation == 7 {
          setupComplete = true
          activateNotifications()
      }
    
      
      // FOR TESTING PURPOSES ONLY
      window?.rootViewController = initialViewController(setupLocation: setupLocation)
      
      // Stay connected when app is in foreground
      stayConnected = true
      
      return true
    }
    
    func startBluetoothConnection() { connectionController = CBCentralManager(delegate: self, queue: nil) }
    func initializeAppBrain()       { appBrain = AppBrain(); appBrain.initialize() }
    
    
    /// Returns the first ViewController in the User's UX based on setup Compleetion
    ///
    /// - Parameter setupLocation: Integer representing the step within the setup that the user occupies
    private func initialViewController(setupLocation: Int) -> UIViewController {
        switch setupLocation {
        case 0:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
        case 1:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConnectVC")
        case 2:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
        case 3:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AquariumFillVC")
        case 4:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasinFillVC")
        case 5:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SunriseVC")
        case 6:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoVC")
        case 7:
            return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        default:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
        }
        
    }
    
    
    func activateNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed.")
            }
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("App WOKE UP IN BACKGROUND. Restarting scan")
        
        if connected { disconnectFromReef() }
        scanForReef()
        completionHandler(.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entering Background State")
        // Continuously re-connect when app is in background
        if connected { disconnectFromReef() }
        stayConnected = false
        appIsInBackground = true
    }

    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Stay connected when app is in foreground
        if connected { disconnectFromReef() }
        stayConnected = true
        appIsInBackground = false
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      
      if let brain = appBrain {
          // If necessary send token to application server.
        brain.setFCMToken(token: fcmToken)
      }
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
    
    func instantNotification(notificationTitle: String, notifcationBody: String){
        
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

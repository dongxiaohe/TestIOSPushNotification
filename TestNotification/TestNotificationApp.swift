//
//  TestNotificationApp.swift
//  TestNotification
//
//  Created by Xiaohe Dong on 4/13/21.
//

import SwiftUI
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let readableCategory = "READABLE"
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("App delegate start")
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if
          let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {
          print("got remote notification")
      
        }
        return true
    }
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }
    
    func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler:
      @escaping (UIBackgroundFetchResult) -> Void
    ) {
      print("got a new push notification")
      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
        completionHandler(.failed)
        return
      }
      print("message is ", aps["custom"]as? String ?? "")
      
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 1
    let userInfo = response.notification.request.content.userInfo
    
    // 2
    let aps = userInfo["aps"] as? [String: AnyObject]
    print("UNUserNotificationCenterDelegate")
    
    // 4
    completionHandler()
  }
}

func getNotificationSettings() {
  UNUserNotificationCenter.current().getNotificationSettings { settings in
    print("Notification settings: \(settings)")
    guard settings.authorizationStatus == .authorized else { return }
    DispatchQueue.main.async {
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}

func registerForPushNotifications() {
    UNUserNotificationCenter.current()
      .requestAuthorization(
        options: [.alert, .sound, .badge]) { granted, _ in
        print("Permission granted: \(granted)")
        guard granted else { return }
        // 1
        let viewAction1 = UNNotificationAction(
          identifier: Identifiers.viewAction,
          title: "Action 1",
          options: [.foreground])
        
        let viewAction2 = UNNotificationAction(
          identifier: Identifiers.viewAction,
          title: "Action 2",
          options: [.foreground])
        
        let viewAction3 = UNNotificationAction(
          identifier: Identifiers.viewAction,
          title: "Action 3",
          options: [.foreground])

        // 2
        let newsCategory = UNNotificationCategory(
          identifier: Identifiers.readableCategory,
          actions: [viewAction1, viewAction2, viewAction3],
          intentIdentifiers: [],
          options: [])

        // 3
        UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
        getNotificationSettings()
      }
}

@main
struct TestNotificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        registerForPushNotifications()
        return WindowGroup {
            ContentView()
        }
    }
    
}

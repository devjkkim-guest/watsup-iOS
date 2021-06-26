//
//  AppDelegate.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/01/20.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
            if !result {
                print("notification denied")
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        Container.shared.initialize()
        if let uuid = UserDefaults.standard.string(forKey: UserDefaultsKey.uuid.rawValue), !uuid.isEmpty {
            window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
        }
        
        let folderPath = try! Realm().configuration.fileURL!.deletingLastPathComponent().path
        print(folderPath)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("deviceToken: \(deviceToken)")
    }
    
    func logout() {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
        API.shared.removeAllTokens()
        DatabaseWorker.shared.removeAll()
        Container.shared.removeAll()
        window?.rootViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
        Container.shared.initialize()
    }
}


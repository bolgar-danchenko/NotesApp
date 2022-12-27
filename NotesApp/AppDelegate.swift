//
//  AppDelegate.swift
//  NotesApp
//
//  Created by Konstantin Bolgar-Danchenko on 26.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var hasAlreadyLaunched: Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CoreDataManager.shared.load()
        
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        if hasAlreadyLaunched {
            hasAlreadyLaunched = true
        } else {
            CoreDataManager.shared.createFirstNote()
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}


}


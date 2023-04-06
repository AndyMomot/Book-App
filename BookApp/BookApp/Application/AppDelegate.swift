
//  AppDelegate.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit
import FirebaseCore
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
    }
}


//
//  SceneDelegate.swift
//  BookApp
//
//  Created by Андрей on 04.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appProvider: AppProvider!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        appProvider = AppProvider(window: window!)
        appProvider.start()
    }
}

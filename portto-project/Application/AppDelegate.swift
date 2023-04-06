//
//  AppDelegate.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        guard let _window = window else {
            return true
        }
        
        appCoordinator = AppCoordinator(window: _window)
        appCoordinator?.start()
        
        return true
    }
}


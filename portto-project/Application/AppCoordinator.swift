//
//  AppCoordinator.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let nvController = UINavigationController()
        
        window.rootViewController = nvController
        window.makeKeyAndVisible()
        
        let assetsListCoordinator = AssetsListCoordinator(navigationController: nvController)
        
        coordinate(to: assetsListCoordinator)
    }
}

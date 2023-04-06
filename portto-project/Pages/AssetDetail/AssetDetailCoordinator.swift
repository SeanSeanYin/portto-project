//
//  AssetDetailCoordinator.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

protocol AssetDetailCoordinatorProtocol: AnyObject {
    
}

class AssetDetailCoordinator: Coordinator, AssetDetailCoordinatorProtocol {
    
    unowned let nvController: UINavigationController
    let asset: AssetDetail
    let image: UIImage?
    
    init(navigationController: UINavigationController, asset: AssetDetail, image: UIImage?) {
        self.nvController = navigationController
        self.asset = asset
        self.image = image
    }
        
    func start() {
                
        let assetsDetailVC =  AssetDetailViewController()
        let assetsDetailVM = AssetDetailViewModel(coordinator: self, asset: asset, assetImage: image)
        
        assetsDetailVC.viewModel = assetsDetailVM
        
        nvController.pushViewController(assetsDetailVC, animated: true)
    }
}

//
//  AssetDetailCoordinator.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

class AssetDetailCoordinator: Coordinator {
    
    unowned let nvController: UINavigationController
    let _asset: AssetDetail
    let _image: UIImage?
    
    init(navigationController: UINavigationController, asset: AssetDetail, image: UIImage?) {
        nvController = navigationController
        _asset = asset
        _image = image
    }
        
    func start() {
                
        let assetsDetailVC =  AssetDetailViewController()
        let assetsDetailVM = AssetDetailViewModel(coordinator: self)
        
        assetsDetailVC.viewModel = assetsDetailVM
        
        nvController.pushViewController(assetsDetailVC, animated: true)
    }
}

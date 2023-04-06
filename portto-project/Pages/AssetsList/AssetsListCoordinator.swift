//
//  AssetsListCoordinator.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

protocol AssetsListCoordinatorProtocol: AnyObject {
    
    func pushAssetDetailPage(_ asset: AssetDetail, image: UIImage?)
}

class AssetsListCoordinator: Coordinator, AssetsListCoordinatorProtocol {
    
    unowned let nvController: UINavigationController
    
    init(navigationController: UINavigationController) {
        nvController = navigationController
    }
    
    
    func start() {
                
        let assetsListVC =  AssetsListViewController()
        let networkManager = NetworkManager()
        let web3Manager = Web3Manager()
        let assetsListVM = AssetsListViewModel(networkManager: networkManager,
                                               web3Manager: web3Manager,
                                               coordinator: self)
        
        assetsListVC.viewModel = assetsListVM
        
        nvController.pushViewController(assetsListVC, animated: true)
    }
    
    func pushAssetDetailPage(_ asset: AssetDetail, image: UIImage?) {
        
        let assetDetailCoordinator = AssetDetailCoordinator(navigationController: nvController, asset: asset, image: image)
        
        coordinate(to: assetDetailCoordinator)
    }
}

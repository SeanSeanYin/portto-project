//
//  AssetDetailViewModel.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import RxSwift
import RxAlamofire
import Alamofire
import RxRelay

protocol AssetDetailViewModelProtocol {
    var navigationBarTitle: BehaviorRelay<String> { get }
}

class AssetDetailViewModel: AssetDetailViewModelProtocol {
    
    let navigationBarTitle = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    private let coordinator: AssetDetailCoordinator
    
    init(coordinator: AssetDetailCoordinator) {
        self.coordinator = coordinator
        
        if let name = coordinator._asset.name {
            navigationBarTitle.accept(name)
        }
    }
}


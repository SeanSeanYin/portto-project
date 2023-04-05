//
//  AssetsListViewModel.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import RxSwift
import RxAlamofire
import Alamofire
import RxRelay

class AssetsListViewModel {
                    
    private let disposeBag = DisposeBag()
    
    private let networkManager: NetworkManager
    private let coordinator: AssetsListCoordinator
    
    let assets = BehaviorRelay<[AssetDetail]>(value: [])
    
    init(networkManager: NetworkManager, coordinator: AssetsListCoordinator) {
        
        self.networkManager = networkManager
        self.coordinator = coordinator
        
        getAssets()
    }
    
    private func getAssets() {
                
        let _ = networkManager
            .getAssets(from: 0)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                                
                switch result {
                    case .success(let newAssets):
                        Observable<[AssetDetail]>.just(newAssets).bind(to: owner.assets).disposed(by: owner.disposeBag)
                    case .failure(_):
                        Observable<[AssetDetail]>.just([]).bind(to: owner.assets).disposed(by: owner.disposeBag)
                }
                
            })
            .disposed(by: disposeBag)
    }
}

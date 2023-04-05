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

protocol AssetsListViewModelProtocol {
    var isLoading: BehaviorRelay<Bool> { get }
    var scrollToEnd: PublishRelay<Void> { get }
}

class AssetsListViewModel: AssetsListViewModelProtocol {
    
    let isLoading =  BehaviorRelay<Bool>(value: true)
    let scrollToEnd =  PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    private let networkManager: NetworkManager
    private let coordinator: AssetsListCoordinator
    
    private var page: Int = 0
    
    let assets = BehaviorRelay<[AssetDetail]>(value: [])
    
    init(networkManager: NetworkManager, coordinator: AssetsListCoordinator) {
        
        self.networkManager = networkManager
        self.coordinator = coordinator
                        
        setupScrollToEnd()
        getAssets()
    }
    
    private func setupScrollToEnd() {
                        
        scrollToEnd
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
        
                debugPrint("setupScrollToEnd")
                
                guard !owner.isLoading.value else {
                    return
                }
                
                owner.page += 1
                owner.getAssets()
            })
            .disposed(by: disposeBag)
    }
    
    private func getAssets() {
                
        isLoading.accept(true)
        
        let _ = networkManager
            .getAssets(page)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                                
                switch result {
                    case .success(let newAssets):
                    var tmpAssets: [AssetDetail] = []

                    if (!owner.assets.value.isEmpty) {
                        tmpAssets.append(contentsOf: owner.assets.value)
                    }
                    tmpAssets.append(contentsOf: newAssets)
                    
                    debugPrint(tmpAssets.count)
                    
                    Observable<[AssetDetail]>.just(tmpAssets).bind(to: owner.assets).disposed(by: owner.disposeBag)
                    
                    case .failure(_):
                        break
                }
                
                Observable<Bool>.just(false).bind(to: owner.isLoading).disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

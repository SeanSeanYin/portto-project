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
    var imageData: PublishRelay<(UIImage, Int, Bool)> { get }
    var selectedId: PublishRelay<Int> { get }
}

class AssetsListViewModel: AssetsListViewModelProtocol {
            
    let isLoading =  BehaviorRelay<Bool>(value: true)
    let scrollToEnd =  PublishRelay<Void>()
    let imageData = PublishRelay<(UIImage, Int, Bool)>()
    let selectedId = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    private let networkManager: NetworkManager
    private let coordinator: AssetsListCoordinator
    
    private var page: Int = 0
    private var cachedImages:[(Int, UIImage)] = []
    
    func imageOfIndex(index: Int) -> UIImage? {
        if let image = cachedImages.first(where: { $0.0 == index }) {
            return image.1
        }
        return nil
    }
    
    let assets = BehaviorRelay<[AssetDetail]>(value: [])
    
    init(networkManager: NetworkManager, coordinator: AssetsListCoordinator) {
        
        self.networkManager = networkManager
        self.coordinator = coordinator
                        
        setupScrollToEnd()
        setupSelectedId()
        getAssets()
    }
    
    private func setupScrollToEnd() {
                        
        scrollToEnd
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                        
                guard !owner.isLoading.value else {
                    return
                }
                
                owner.page += 1
                owner.getAssets()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSelectedId() {
        selectedId
            .withUnretained(self)
            .subscribe(onNext: { owner, id in
                let tmpAssets = owner.assets.value
                if let asset = tmpAssets.first(where: { $0.id == id }), let index = tmpAssets.firstIndex(where: { $0 == asset }) {
                    let image = owner.imageOfIndex(index: index)
                    owner.coordinator.pushAssetDetailPage(asset, image: image)
                }
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
                                        
                    for (index, asset) in tmpAssets.enumerated() {
                        if let url = asset.imageUrl {
                            owner.getImage(index, url: url)
                        }
                    }
                    
                    Observable<[AssetDetail]>.just(tmpAssets).bind(to: owner.assets).disposed(by: owner.disposeBag)
                    
                    case .failure(_):
                        break
                }
                
                Observable<Bool>.just(false).bind(to: owner.isLoading).disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    private func getImage(_ index: Int, url: String) {
        
        if let target = cachedImages.first(where: { $0.0 == index }) {
            imageData.accept((target.1, index, true))
        } else {
            networkManager
                .downloadImage(index, url: url)
                .withUnretained(self)
                .subscribe(onNext: { owner, result in
                    switch result {
                        case .success(let arg):
                            owner.cachedImages.append(arg)
                            owner.imageData.accept((arg.1, arg.0, true))
                        case .failure(_):
                            owner.imageData.accept((UIImage(), index, false))
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}

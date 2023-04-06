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
    var tapPermalinkButton: PublishRelay<Void> { get }
    var uiImage: BehaviorRelay<UIImage?> { get }
    var name: BehaviorRelay<String?> { get }
    var description: BehaviorRelay<String?> { get }
}

class AssetDetailViewModel: AssetDetailViewModelProtocol {
                
    let navigationBarTitle = BehaviorRelay<String>(value: "")
    let tapPermalinkButton = PublishRelay<Void>()
    let uiImage = BehaviorRelay<UIImage?>(value: nil)
    let name = BehaviorRelay<String?> (value: nil)
    let description = BehaviorRelay<String?> (value: nil)
    
    private let disposeBag = DisposeBag()
    private let coordinator: AssetDetailCoordinator
    private let asset: AssetDetail
    private let image: UIImage?
    
    init(coordinator: AssetDetailCoordinator, asset: AssetDetail, assetImage: UIImage?) {
        
        self.coordinator = coordinator
        self.asset = asset
        self.image = assetImage
        
        setupNavigationBarTitle()
        setupAssetRelay()
        setupTapPermalinkButton()
    }
    
    private func setupNavigationBarTitle() {
        
        if let name = asset.collection?.name {
            navigationBarTitle.accept(name)
        }
    }
    
    private func setupAssetRelay() {
        
        uiImage.accept(image)
        name.accept(asset.name)
        description.accept(asset.description)
    }
    
    private func setupTapPermalinkButton() {
        
        tapPermalinkButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                
                if let permalink = owner.asset.permalink, let url = URL(string: permalink), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
}

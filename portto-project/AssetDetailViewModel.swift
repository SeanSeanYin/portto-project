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
    var image: BehaviorRelay<UIImage?> { get }
    var name: BehaviorRelay<String?> { get }
    var description: BehaviorRelay<String?> { get }
}

class AssetDetailViewModel: AssetDetailViewModelProtocol {
                
    let navigationBarTitle = BehaviorRelay<String>(value: "")
    let tapPermalinkButton = PublishRelay<Void>()
    let image = BehaviorRelay<UIImage?>(value: nil)
    let name = BehaviorRelay<String?> (value: nil)
    let description = BehaviorRelay<String?> (value: nil)
    
    private let disposeBag = DisposeBag()
    private let coordinator: AssetDetailCoordinator
    
    init(coordinator: AssetDetailCoordinator) {
        self.coordinator = coordinator
    
        if let name = coordinator._asset.collection?.name {
            navigationBarTitle.accept(name)
        }
        
        image.accept(coordinator._image)
        name.accept(coordinator._asset.name)
        description.accept(coordinator._asset.description)
        
        tapPermalinkButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                
                if let permalink = owner.coordinator._asset.permalink, let url = URL(string: permalink), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)
    }
}

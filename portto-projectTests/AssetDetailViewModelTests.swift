//
//  AssetDetailViewModelTests.swift
//  portto-projectTests
//
//  Created by ChienHsiang Yin on 2023/4/6.
//

import XCTest
import RxSwift

@testable import portto_project

final class AssetDetailViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var sut: AssetDetailViewModel!
    private var navigationController: UINavigationController!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        disposeBag = DisposeBag()
        navigationController = UINavigationController()
        let asset = AssetDetail(id: 123, imageUrl: nil, name: "Web", collection: AssetCollection(name: "333"), description: "new word", permalink: "wcs://random.com")
        let image = UIImage(systemName: "paperplane.fill")
        sut = AssetDetailViewModel(coordinator: AssetDetailCoordinator(
                                                navigationController: navigationController,asset: asset, image: image),
                                   asset: asset,
                                   assetImage: image)
    }

    override func tearDownWithError() throws {
        
        disposeBag = nil
        navigationController = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testNavigationBarGetCorrectTitle() throws {
        
        sut.navigationBarTitle
            .withUnretained(self)
            .subscribe(onNext: { owner, string in
                
                XCTAssertTrue(string == "333", "The collection name should be 333 but we got \(string)")
            })
            .disposed(by: disposeBag)
    }
}

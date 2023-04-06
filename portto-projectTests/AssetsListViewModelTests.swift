//
//  AssetsListViewModelTests.swift
//  portto-projectTests
//
//  Created by ChienHsiang Yin on 2023/4/6.
//

import XCTest
import RxSwift

@testable import portto_project

final class AssetsListViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var sut: AssetsListViewModel!
    private var web3Manager: Web3Protocol!
    private var networkManager: NetworkProtocol!
    private var navigationController: UINavigationController!
    private var coordinator: AssetsListCoordinator!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        disposeBag = DisposeBag()
        web3Manager = MockWeb3Manager()
        networkManager = MockNetworkManager()
        navigationController = UINavigationController()
        coordinator = AssetsListCoordinator(navigationController: navigationController)
        
        sut = AssetsListViewModel(networkManager: networkManager, web3Manager: web3Manager, coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        
        disposeBag = nil
        navigationController = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testGetAssets_From0To19() throws {

        sut.assets
            .withUnretained(self)
            .subscribe(onNext: { (owner, assets) in
                
                XCTAssertTrue(assets.count == 20, "Count is :\(assets.count) but shoule be 20")
                XCTAssertTrue(assets[11].id == 11, "Asset id is :\(assets.count) but shoule be 11")
            })
            .disposed(by: disposeBag)
    }
    
    func testGetImageAtIndex11() throws {
        
        sut.imageData
            .withUnretained(self)
            .subscribe(onNext: { (owner, args) in
                
                let (image, index, _) = args
                
                XCTAssertEqual(UIImage(systemName: "paperplane.fill"), image, "image should be UIImage(systemName: paperplane.fill)")
                XCTAssertEqual(11, index, "index should be 11 but we got \(index)")
            })
            .disposed(by: disposeBag)
    }
    
    func testWhenScrollToEndOnce_GetAssets_From0To39 () throws {
                
        sut.scrollToEnd.accept(())
        
        sut.assets
            .withUnretained(self)
            .subscribe(onNext: { (owner, assets) in
                
                XCTAssertTrue(assets.count == 40, "Count is :\(assets.count) but shoule be 40")
                XCTAssertTrue(assets.last?.id == 39, "Asset id is :\(assets.last?.id) but shoule be 39")
            })
            .disposed(by: disposeBag)
    }
}

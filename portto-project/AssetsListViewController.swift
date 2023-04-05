//
//  AssetsListViewController.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit
import RxSwift
import RxCocoa

class AssetsListViewController: UIViewController {
            
    var viewModel: AssetsListViewModel!
    
    private let screenBounds = UIScreen.main.bounds
    private let disposeBag = DisposeBag()
    
    private lazy var assetCellSize: CGSize = {
        return CGSize(width: screenBounds.width * 0.45, height: screenBounds.width * 0.7)
    }()
        
    private lazy var assetsListView: UICollectionView = {        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(AssetCell.self, forCellWithReuseIdentifier: AssetCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindCollectionView()
    }
            
    private func bindCollectionView() {
        
        view.addSubview(assetsListView)

        NSLayoutConstraint.activate([
            assetsListView.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            assetsListView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            assetsListView.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            assetsListView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        viewModel.assets.bind(to: assetsListView.rx
            .items(cellIdentifier: AssetCell.identifier, cellType: AssetCell.self)) { (index, item, cell) in
                
                cell.nameLabel.text = item.name
            }
            .disposed(by: disposeBag)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = assetCellSize
        let cellsPerRow: Int = 2
        let inset = (screenBounds.width - (CGFloat(cellsPerRow) * assetCellSize.width)) / CGFloat((cellsPerRow + 1))
        layout.sectionInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        return layout
    }
}

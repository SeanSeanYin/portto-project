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
    private var assetsListViewBottomConstraint: NSLayoutConstraint!
    private let activityIndicatorHeight: CGFloat = 44
    
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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
        setupActivityIndicator()
    }
            
    private func setupCollectionView() {
        
        view.addSubview(assetsListView)
        assetsListViewBottomConstraint = assetsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            assetsListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            assetsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            assetsListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            assetsListViewBottomConstraint
        ])
        
        viewModel.assets.bind(to: assetsListView.rx
            .items(cellIdentifier: AssetCell.identifier, cellType: AssetCell.self)) { (index, item, cell) in
                
                cell.nameLabel.text = item.name
            }
            .disposed(by: disposeBag)
        
        assetsListView.rx.willDisplayCell
            .withUnretained(self)
            .do(onNext: {(owner, arg) in
                
                let (_ , indexPath) = arg
                
                let currentSection = owner.assetsListView.numberOfSections
                let currentItem = owner.assetsListView.numberOfItems(inSection: indexPath.section)
                let isScrollToEnd = (indexPath.section == currentSection - 1 && indexPath.row == currentItem - 1)
                
                debugPrint(indexPath.section, indexPath.item, currentSection, currentItem, isScrollToEnd)
                
                if isScrollToEnd {
                    Observable<Void>.just(()).bind(to: owner.viewModel.scrollToEnd).disposed(by: owner.disposeBag)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
    private func setupActivityIndicator() {
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: activityIndicatorHeight),
            activityIndicator.heightAnchor.constraint(equalToConstant: activityIndicatorHeight)
        ])
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .do(onNext: { (owner, isLoading) in
                owner.updateBottomConstraint(isLoading)
            })
            .flatMap({ arg -> Observable<Bool> in
                return Observable.just(arg.1)
            })
            .bind(to: activityIndicator.rx.isAnimating)
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
    
    private func updateBottomConstraint(_ isLoading: Bool) {
        assetsListViewBottomConstraint.constant = isLoading ? -activityIndicatorHeight : 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

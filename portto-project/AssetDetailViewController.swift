//
//  AssetDetailViewController.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit
import RxSwift

class AssetDetailViewController: UIViewController {
        
    var viewModel: AssetDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)                
    }
}

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
    
    private let linkButtonHeight = 60.0
    private lazy var linkButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitleColor(.darkText, for: .normal)
        button.setTitle("Permalink", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLinkButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)                
    }
    
    private func setupLinkButton() {
        
        view.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            
            linkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            linkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            linkButton.heightAnchor.constraint(equalToConstant: linkButtonHeight)
        ])
        
        linkButton.rx.tap
            .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.tapPermalinkButton)
            .disposed(by: disposeBag)
    }
}

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
    
    private var imageViewHeightConstraint: NSLayoutConstraint!
    
    private let componentDistance: CGFloat = 20.0
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
    
    private lazy var scrollView: UIScrollView = {
        
        let sv = UIScrollView(frame: view.frame)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isUserInteractionEnabled = true
        sv.isScrollEnabled = true
        
        return sv
    }()
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        _imageView.clipsToBounds = true
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.isUserInteractionEnabled = true
        
        return _imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.tintColor = .lightText
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
                             
        setupLinkButton()
        setupScrollView()
        setupImageView()
        setupNameLabel()
        setupDescriptionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
     
    private func setupNavigationBar() {
        
        viewModel.navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    private func setupLinkButton() {
        
        view.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            
            linkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            linkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -componentDistance),
            linkButton.heightAnchor.constraint(equalToConstant: linkButtonHeight)
        ])
        
        linkButton.rx.tap
            .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.tapPermalinkButton)
            .disposed(by: disposeBag)
    }
    
    private func setupScrollView() {
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: linkButton.topAnchor),
        ])
    }
    
    private func setupImageView() {
        
        scrollView.addSubview(imageView)
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageViewHeightConstraint
        ])
        
        viewModel.image
            .withUnretained(self)
            .do(onNext: { owner, image in
                if let height = image?.size.height, let width = image?.size.width {
                    let newHeight = height / width * owner.view.frame.width
                    owner.updateHeightConstraint(newHeight)
                }
            })
            .map { return $1 }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func setupNameLabel() {
        
        scrollView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([            
            nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            nameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: componentDistance),
        ])
        
        viewModel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupDescriptionLabel() {
        
        scrollView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: componentDistance),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -(linkButtonHeight + componentDistance)),
        ])
        
        viewModel.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func updateHeightConstraint(_ height: CGFloat) {
        
        imageViewHeightConstraint.constant = height        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

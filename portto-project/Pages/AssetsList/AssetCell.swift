//
//  AssetCell.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import UIKit

class AssetCell: UICollectionViewCell {
            
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        _imageView.clipsToBounds = true
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        return _imageView
    }()
    
    static let identifier: String = "AssetCell"
    private let insert = CGFloat(10)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to init AssetCell")
    }
    
    private func setup() {
        
        backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: insert),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insert),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -insert),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: insert),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: insert),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -insert),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
}

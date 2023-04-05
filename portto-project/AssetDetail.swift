//
//  AssetDetail.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import Foundation

struct AssetsResponse: Codable {
    var assets: [AssetDetail]
    
    enum CodingKeys: String, CodingKey {
        case assets
    }
}

struct AssetDetail: Codable, Equatable {
    
    static func == (lhs: AssetDetail, rhs: AssetDetail) -> Bool {
        return lhs.id == rhs.id
    }
        
    var id: Int?
    var imageUrl: String?
    var name: String?
    var collection: AssetCollection?
    var description: String?
    var permalink: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id, name, collection, description, permalink
        case imageUrl = "image_url"
    }
    
    
}

struct AssetCollection: Codable {

    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

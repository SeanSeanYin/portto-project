//
//  NetworkManager.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/5.
//

import RxAlamofire
import Alamofire
import RxSwift
import Moya
import Foundation

enum NetworkError: Error {
    case FailedRequest
    case DecodeFailure
    case UnknownError
}

enum TestNets {
    case assets(offset: Int, limit: Int = 20, address: String = "0x85fD692D2a075908079261F5E351e7fE0267dB02")
    case downloadImage(url: String)
}

extension TestNets: TargetType {
        
    var baseURL: URL {
        switch self {
            case .assets: return URL(string: "https://testnets-api.opensea.io")!
            case .downloadImage(let url) : return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
            case .assets:
                return "/api/v1/assets"
            case .downloadImage:
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .assets, .downloadImage: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .assets(let offset, let limit, let address):
                var params: [String: Any] = [:]
                params["owner"] = address
                params["offset"] = offset
                params["limit"] = limit
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            case .downloadImage:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

class NetworkManager {
    
    private let disposeBag = DisposeBag()
    private static let limitaionPerPage = 20

    var provider: MoyaProvider<TestNets>!
    
    init(_ provider: MoyaProvider<TestNets> = MoyaProvider<TestNets>()) {
        self.provider = provider
    }
        
    func getAssets(_ page: Int, limit: Int = limitaionPerPage) -> Observable<Result<[AssetDetail], Error>> {
        
        return Observable.create { [self] (observer) -> Disposable in
                        
            let _ = provider.rx
                .request(.assets(offset: page * limit, limit: limit))
                .timeout(RxTimeInterval.milliseconds(5000), scheduler: MainScheduler.instance)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { response in
                    
                    guard let assets = try? JSONDecoder().decode(AssetsResponse.self, from: response.data) else {
                        observer.onNext(.failure(NetworkError.DecodeFailure))
                        return
                    }
                                        
                    observer.onNext(.success(assets.assets))
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                })

            return Disposables.create()
        }
    }
    
    func downloadImage(_ index: Int, url: String) -> Observable<Result<(Int, UIImage), Error>> {
        
        return Observable.create { [self] (observer) -> Disposable in
                        
            let _ = provider.rx
                .request(.downloadImage(url: url))
                .observe(on: MainScheduler.instance)
                .mapImage()
                .subscribe(onSuccess: { image in
                                        
                    observer.onNext(.success((index, image)))
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                })

            return Disposables.create()
        }
    }
}

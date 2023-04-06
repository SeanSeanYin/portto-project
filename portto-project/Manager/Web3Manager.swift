//
//  Web3Manager.swift
//  portto-project
//
//  Created by ChienHsiang Yin on 2023/4/6.
//

import web3
import BigInt
import RxSwift

enum Web3Error: Error {
    case FailedRequest
    case GetBalanceFailure
    case UnknownError
}

protocol Web3Protocol {
    
    func getBalance(_ address:String) async -> Observable<Result<String, Error>>
}

class Web3Manager: Web3Protocol {
    
    private let ulrString = "https://rpc.ankr.com/eth_goerli"
    
    func getBalance(_ address:String = EthAddress.GoerliTestOne.rawValue) async -> Observable<Result<String, Error>> {
                           
        return Observable.create { [self] (observer) -> Disposable in
        
            guard let clientUrl = URL(string: ulrString) else {
                debugPrint("Failed to generate url: ")
                observer.onError(Web3Error.FailedRequest)
                return Disposables.create()
            }
                    
            let client = EthereumHttpClient(url: clientUrl)
            let ethAddress = EthereumAddress(address)
            
            Task {
                do {
                    let balance = try await client.eth_getBalance(address: ethAddress, block: .Latest)
                    let balanceEth = balance.quotientAndRemainder(dividingBy: 100000000000000000)
                    let ethString = "\(balanceEth.quotient).\(balanceEth.remainder) ETH"
                    observer.onNext(.success(ethString))
                    observer.onCompleted()
                } catch (let error) {
                    debugPrint(error)
                    observer.onError(Web3Error.GetBalanceFailure)
                }
            }
            
            return Disposables.create()
        }
    }
}


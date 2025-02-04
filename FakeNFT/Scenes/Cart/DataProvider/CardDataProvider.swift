//
//  CardDataProvider.swift
//  FakeNFT
//
//  Created by Vitaly on 10.10.2023.
//

import Foundation

protocol CardDataProviderProtocol {
    var order: [NftDto] { get }
    var orderChanged: NSNotification.Name { get }
    var orderCleared: Notification.Name { get }
    
    func getOrder(_ completion: @escaping (Result<String, Error>) -> Void)
    func getNFT(id: String, _ completion: @escaping (Result<NftDto, Error>) -> Void)
    func removeItemFromCart(idForRemove: String,  _ completion: @escaping (Result<[String], Error>) -> Void)
    func removeAllItemFromCart( _ completion: @escaping (Result<Int, Error>) -> Void)
}

final class CardDataProvider: CardDataProviderProtocol {
    
    static var shared = CardDataProvider()
    static private let baseURL = "https://651ff0cc906e276284c3c1bc.mockapi.io/api/v1/"
    
    struct NFSRequest: NetworkRequest {
        let nfsID: String
        var endpoint: URL? = nil
        init(nfsID: String) {
            self.nfsID = nfsID
            self.endpoint =  URL(string: baseURL + "nft/\(nfsID)")
        }
    }

    struct OrderRequest: NetworkRequest {
        var endpoint: URL? = URL(string: baseURL +  "orders/1")
    }
    
    struct СartUpdateRequest: NetworkRequest {
        var httpMethod: HttpMethod { .put }
        var dto: Encodable?
        var endpoint: URL? = URL(string: baseURL + "orders/1")
        
        init(cartIDs: [String]) {
            self.dto = UpdateCartDto(nfts: cartIDs)
        }
    }

    struct СartClearRequest: NetworkRequest {
        var httpMethod: HttpMethod { .put }
        var dto: Encodable?
        var endpoint: URL? = URL(string: baseURL + "orders/1")
        
        init() {
            self.dto = UpdateCartDto(nfts: [])
        }
    }
    
   
    
    var networkClient: NetworkClient?
    
    let orderChanged = Notification.Name("CartUpdated")
    let orderCleared = Notification.Name("CartCleared")
    
    private (set) var orderIDs: [String] = []
    private (set) var order: [NftDto] = [] {
        didSet {
            // если колличество загруженных nft равняется колличеству nftid, значит все запросы отработали и можно перегрузить отображать корзину
            // TODO: переделать на DispatchGroup и избавиться от этого условия
            if orderIDs.count == order.count {
                NotificationCenter.default.post(name: orderChanged, object: nil )
                if(order.count == 0) {
                    NotificationCenter.default.post(name: orderCleared, object: nil )
                }
            }
        }
    }
    
    private init(networkClient: NetworkClient? = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    /// получение корзины. По результатам работы функции заполняется свойства orderIDs и order
    func getOrder(_ completion: @escaping (Result<String, Error>) -> Void) {
        let orderRequest = OrderRequest()
        self.orderIDs.removeAll()
        
        networkClient?.send(request: orderRequest , type: OrderDto.self)  { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.orderIDs.append(contentsOf: data.nfts)
                    self.order.removeAll()
                    for nftID in data.nfts {
                        getNFT(id: nftID) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case let .success(ntf):
                                self.order.append(ntf)
                            case let .failure(error):
                                print(error)
                                completion(.failure(error))
                            }
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        return
    }
    /// получение отдельного NFT по id
    func getNFT(id: String, _ completion: @escaping (Result<NftDto, Error>) -> Void) {
        let ntfsRequest = NFSRequest(nfsID: id)
        networkClient?.send(request: ntfsRequest , type: NftDto.self)  { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
    
    /// удаление  элемента из корзины
    func removeItemFromCart(idForRemove: String,  _ completion: @escaping (Result<[String], Error>) -> Void) {
        
        var newCartIds = orderIDs
        newCartIds.removeAll(where: {$0 == idForRemove})
        
        let ntfsRequest = СartUpdateRequest(cartIDs: newCartIds)
        networkClient?.send(request: ntfsRequest , type: UpdateCartDto.self)  { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    orderIDs.removeAll(where: {$0 == idForRemove})
                    order.removeAll(where: {$0.id == idForRemove})
                    
                    completion(.success(data.nfts))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
    
    /// очистка корзины
    func removeAllItemFromCart( _ completion: @escaping (Result<Int, Error>) -> Void) {
        let ntfsRequest = СartClearRequest()
        networkClient?.send(request: ntfsRequest , type: UpdateCartDto.self)  { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    orderIDs.removeAll()
                    order.removeAll()
                    completion(.success(data.nfts.count))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
}

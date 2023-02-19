//
//  ProductService.swift
//  ProductBrand
//
//  Created by Anand  on 14/02/23.
//

import Foundation
import Combine

class ProductService {
    var cancellables: [AnyCancellable] = []
    
    // MARK: - Input
    let errorSubject = PassthroughSubject<ServiceError, Never>()
    
    // MARK: - Output
    @Published var error: ServiceError?
    
    // MARK: - Requests
    func fetchProducts() -> AnyPublisher<ProductRequest.Response, Never> {
        
        return response(from: ProductRequest())
            .catch { [weak self] error -> Empty<ProductRequest.Response, Never> in
                self?.errorSubject.send(error)
                return .init()
            }
            .share()
            .eraseToAnyPublisher()
        
    }
}

extension ProductService : Service {
    var baseURLString: String { "https://run.mocky.io/v3/" }
}

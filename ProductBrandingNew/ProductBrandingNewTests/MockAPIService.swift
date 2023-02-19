//
//  MockAPIService.swift
//  ProductBrandTests
//
//  Created by Anand  on 14/02/23.
//

import SwiftUI
import Combine
@testable import ProductBrandingNew

final class MockAPIService: ProductService {
    
    override func fetchProducts() -> AnyPublisher<ProductRequest.Response, Never> {
        return response(from: MockRequest())
            .catch { [weak self] error -> Empty<ProductRequest.Response, Never> in
                self?.errorSubject.send(error)
                return .init()
            }
            .share()
            .eraseToAnyPublisher()
    }
}

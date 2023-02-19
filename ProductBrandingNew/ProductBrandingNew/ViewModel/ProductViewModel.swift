//
//  ProductViewModel.swift
//  ProductBrandingNew
//
//  Created by Anand  on 18/02/23.
//

import Foundation
import SwiftUI
import Combine

final class ProductViewModel: ViewModel {
    
    private let productService: ProductService
    /// On create of viewmodel initializes the product service
    ///  - Parameters:
    ///        - service:  A default service creared when Viewmodel initialized.
    init(service: ProductService = ProductService()) {
        self.productService = service
        bind()
    }
    
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    var cancellables: [AnyCancellable] = []
    
    @Published var isScreenDirty:  Bool = false {
        didSet {
            if isScreenDirty {
                // Avoiding crash by adding a small delay
                // Crash reason: ImageOverlay Object is binded to observe the isfavorite state.
                // On navigating back to refresh the array & View is consuming 0.4 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.updateFavoriteList()
                }
            }
        }
    }
    @Published var isAppLoading:  Bool = false
    
    @Published var products: Products = Products(items: []) {
        willSet {
            self.isAppLoading = false
        }
    }
    
    @Published var segmentCurrentIndex: Int = 0 {
        didSet {
            updateFavoriteList()
        }
    }
    
    @Published var favoriteItems: [Product] = []
    
    enum Input: Equatable {
        case onAppear
        case onTestExecute
    }
    
    func apply(input: Input) {
        switch input {
        case .onAppear:
            self.isAppLoading = true
            self.onAppearSubject.send()
        case .onTestExecute: prepareMockObject()
        }
    }
    
    /// Loads the service when view appears
    ///  On bind, the following subjects are invoked
    ///   - onAppearSubject:  Fetchs the products by call the api
    private func bind() {
        onAppearSubject
            .flatMap { [productService] _ in
                productService.fetchProducts()
            }
            .assign(to: \.products, on: self)
            .store(in: &cancellables)
    }
    
    /// Refreshs the product based on the productId & status of Product
    ///  - Parameters:
    ///     - productId: Requires Product Id to map
    ///     - status: Required to update isfavorite status of product
    func refreshProductItem(for productId: String, status: Bool) {
        
        if let index = products.items.firstIndex(where: { $0.productId == productId }) {
            products.items[index].isFavorite = status
        }
        favoriteItems = products.items.filter { $0.isFavorite }
    }
    
    /// On navigate back updates the  favorite Item list
    private func updateFavoriteList() {
        
        for item in favoriteItems {
            
            if let index = products.items.firstIndex(where: { $0.productId == item.productId }) {
                products.items[index].isFavorite = item.isFavorite
            }
        }
        
        favoriteItems = products.items.filter { $0.isFavorite }
        
    }
    
    func prepareMockObject() {
        let product = Product(
            title: "Mock Title",
            productId: "123",
            imageURL: "",
            brand: "Mock Brand", price: [], rating: 0.4)
        products.items.append(product)
    }
    
}

//
//  APIServiceTest.swift
//  ProductBrandTests
//
//  Created by Anand  on 14/02/23.
//

import XCTest
import Combine
@testable import ProductBrandingNew

final class APIServiceTest: XCTestCase {

    var cancellables: [AnyCancellable] = []

    func testRetrieveProductsValidObject() {
        let apiService = MockAPIService()
        let viewModel = ProductViewModel(service: apiService)
        viewModel.apply(input: .onTestExecute)
        XCTAssertTrue(!viewModel.products.items.isEmpty)
    }
    
    func testProductEmptyObject() {
        let apiService = MockAPIService()
        let viewModel = ProductViewModel(service: apiService)
        viewModel.apply(input: .onAppear)
        XCTAssertTrue(viewModel.products.items.isEmpty)
    }
    
    func testProductApi() {
        
        let apiService = MockAPIService()
        let expectation = self.expectation(description: "MockRequestAPI")
        
        var mockProducts: Products = Products(items: [])
        var error: Error?

        apiService.fetchProducts().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let encounteredError):
                error = encounteredError
            }
            
            // Fullfilling our expectation to unblock
            // our test execution:
            expectation.fulfill()
        } receiveValue: { values in
            mockProducts = values
        }.store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)
        
        // Asserting that our Combine pipeline yielded the
               // correct output:
        XCTAssertNil(error)
        XCTAssertTrue(mockProducts.items.count > 0)
    }
    

}

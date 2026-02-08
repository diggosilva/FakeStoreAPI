//
//  ProductDetailViewModelTests.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 06/02/26.
//

import XCTest
import Combine
@testable import FakeStoreAPI

@MainActor
final class ProductDetailViewModelTests: XCTestCase {
        
    private var product: Product!
    private var serviceMock: FeedServiceMock!
    private var sut: ProductDetailViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        product = .mock()
        serviceMock = FeedServiceMock()
        sut = ProductDetailViewModel(product: product, service: serviceMock)
        cancellables = []
    }
    
    override func tearDown() {
        product = nil
        serviceMock = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_updateProduct_returnsInjectedProduct() {
        let returnedProduct = sut.updateProduct()
        XCTAssertEqual(returnedProduct, product)
    }
    
    func test_addToCart_addsProductToCart() async throws {
        // Arrange
        let cartManagerMock = CartManagerMock()
        sut = ProductDetailViewModel(
            product: product,
            service: serviceMock,
            cartManager: cartManagerMock
        )
        
        // Act
        try await sut.addToCart()
        
        // Assert
        XCTAssertTrue(cartManagerMock.contains(product))
    }
}

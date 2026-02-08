//
//  CartViewModelTests.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 07/02/26.
//

import XCTest
import Combine
@testable import FakeStoreAPI

@MainActor
final class CartViewModelTests: XCTestCase {

    private var sut: CartViewModel!
    private var serviceMock: CartServiceMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        serviceMock = CartServiceMock()
        cancellables = []
        CartManager.shared.clearCart()
        sut = CartViewModel(service: serviceMock)
    }

    override func tearDown() {
        CartManager.shared.clearCart()
        sut = nil
        serviceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init_startsWithIdleStateAndEmptyCart() {
        XCTAssertEqual(sut.totalPrice, 0)
        XCTAssertTrue(sut.items.isEmpty)

        let expectation = XCTestExpectation(description: "Initial state is idle")

        sut.statePublisher
            .sink { state in
                XCTAssertEqual(state, .idle)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func test_totalPrice_isCalculatedCorrectly() {
        let product1 = Product.mock(id: 1, price: 10)
        let product2 = Product.mock(id: 2, price: 20)
        
        CartManager.shared.add(product1)
        CartManager.shared.add(product1)
        CartManager.shared.add(product2)
        
        XCTAssertEqual(sut.totalPrice, 40)
    }
    
    func test_removeItem_removesAllItemsFromCart() {
        let product = Product.mock(id: 1)

        CartManager.shared.add(product)
        CartManager.shared.add(product)

        XCTAssertEqual(sut.items.first?.quantity, 2)

        sut.removeItem(at: 0)

        XCTAssertTrue(sut.items.isEmpty)
    }
    
    func test_incrementItem_addsProductToCart() {
        let product = Product.mock(id: 1)
        CartManager.shared.add(product)
        
        sut.incrementItem(id: 1)
        
        XCTAssertEqual(sut.items.first?.quantity, 2)
    }
    
    func test_decrementItem_removesOneItem() {
        let product = Product.mock(id: 1)
        CartManager.shared.add(product)
        CartManager.shared.add(product)
        
        sut.decrementItem(id: 1)
        
        XCTAssertEqual(sut.items.first?.quantity, 1)
    }
    
    func test_checkout_withEmptyCart_emitsErrorState() async {
        let expectation = XCTestExpectation(description: "State should be .error")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, "Seu carrinho está vazio. Adicione produtos antes de finalizar!")
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        await sut.checkout()
        
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(serviceMock.addNewCartCalled)
    }
    
    func test_checkout_success_emitsLoadedStateAndClearsCart() async {
        let product = Product.mock(id: 1)
        CartManager.shared.add(product)

        let expectation = XCTestExpectation(description: "Loaded state emitted")

        sut.statePublisher
            .dropFirst(2) // idle → loading → loaded
            .sink { state in
                XCTAssertEqual(state, .loaded)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.checkout()

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(serviceMock.addNewCartCalled)
        XCTAssertTrue(sut.items.isEmpty)
    }
    
    func test_checkout_failure_emitsErrorState() async {
        let product = Product.mock(id: 1)
        CartManager.shared.add(product)

        serviceMock.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Error state emitted")

        sut.statePublisher
            .dropFirst(2)
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.checkout()

        wait(for: [expectation], timeout: 1)
    }

}

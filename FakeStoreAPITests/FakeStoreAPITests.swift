//
//  FakeStoreAPITests.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 05/02/26.
//

import XCTest
import Combine
@testable import FakeStoreAPI

@MainActor
final class FeedViewModelTests: XCTestCase {
    
    private var serviceMock: ServiceMock!
    private var sut: FeedViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        serviceMock = ServiceMock()
        sut = FeedViewModel(service: serviceMock)
        cancellables = []
    }
        
    override func tearDown() {
        sut = nil
        serviceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init_shouldStartWithIdleState() {
        XCTAssertEqual(sut.currentState, .idle)
        XCTAssertEqual(sut.numberOfRows(), 0)
    }
    
    func test_fetchProducts_success_shouldEmitLoadingAndLoaded() async {
        // Given
        serviceMock.productsToReturn = [
            .mock(title: "Camiseta", category: .menSClothing),
            .mock(title: "Notebook", category: .electronics)
        ]

        var receivedStates: [FeedVCStates] = []

        sut.statePublisher
            .sink { receivedStates.append($0) }
            .store(in: &cancellables)

        // When
        await sut.fetchProducts()

        // Then
        XCTAssertEqual(receivedStates, [.idle, .loading, .loaded])
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(sut.getProducts().first?.title, "Camiseta")
        XCTAssertEqual(sut.currentState, .loaded)
    }
    
    func test_fetchProducts_failure_shouldEmitErrorState() async {
        // Given
        serviceMock.shouldReturnError = true

        var receivedState: FeedVCStates?

        sut.statePublisher
            .dropFirst() // ignora idle
            .sink { receivedState = $0 }
            .store(in: &cancellables)

        // When
        await sut.fetchProducts()

        // Then
        guard case .error(let message) = receivedState else {
            XCTFail("Expected error state")
            return
        }

        XCTAssertTrue(message.contains("Ocorreu um erro"))
    }
    
    func test_numberOfRows_and_productForRow() async {
        // Given
        serviceMock.productsToReturn = [
            .mock(title: "Produto A"),
            .mock(title: "Produto B")
        ]

        await sut.fetchProducts()

        // Then
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(sut.productForRow(at: 1).title, "Produto B")
    }
    
    func test_search_shouldFilterByTitleIgnoringAccents() async {
        // Given
        serviceMock.productsToReturn = [
            .mock(title: "Café Premium"),
            .mock(title: "Chá Verde")
        ]

        await sut.fetchProducts()

        // When
        sut.search(text: "cafe")

        // Then
        XCTAssertEqual(sut.numberOfRows(), 1)
        XCTAssertEqual(sut.getProducts().first?.title, "Café Premium")
    }
    
    func test_search_shouldFilterByCategory() async {
        // Given
        serviceMock.productsToReturn = [
            .mock(title: "Notebook", category: .electronics),
            .mock(title: "Camisa Polo", category: .menSClothing)
        ]

        await sut.fetchProducts()

        // When
        sut.search(text: "men's clothing")

        // Then
        XCTAssertEqual(sut.numberOfRows(), 1)
        XCTAssertEqual(sut.getProducts().first?.category, .menSClothing)
    }
    
    func test_search_emptyText_shouldReturnAllProducts() async {
        // Given
        serviceMock.productsToReturn = [
            .mock(title: "A"),
            .mock(title: "B"),
            .mock(title: "C")
        ]

        await sut.fetchProducts()

        // When
        sut.search(text: "")

        // Then
        XCTAssertEqual(sut.numberOfRows(), 3)
    }
}

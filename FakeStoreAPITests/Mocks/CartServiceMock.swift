//
//  CartServiceMock.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 08/02/26.
//

import Foundation
@testable import FakeStoreAPI

final class CartServiceMock: ServiceProtocol {

    // MARK: - Configuração
    var shouldReturnError = false
    var errorToThrow: Error = ServiceError.invalidResponse

    // MARK: - Spies
    private(set) var addNewCartCalled = false
    private(set) var receivedCart: Cart?

    // MARK: - Feed
    var productsToReturn: [Product] = []

    func getProducts() async throws -> [Product] { [] }

    // MARK: - Cart
    func addNewCart(cart: Cart) async throws -> Cart {
        addNewCartCalled = true
        receivedCart = cart

        if shouldReturnError {
            throw errorToThrow
        }
        return cart
    }
}

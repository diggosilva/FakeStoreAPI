//
//  ServiceMock.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 05/02/26.
//

@testable import FakeStoreAPI

final class ServiceMock: ServiceProtocol {
    
    var shouldReturnError = false
    var productsToReturn: [Product] = []
    var errorToThrow: Error = ServiceError.invalidResponse
    
    func getProducts() async throws -> [Product] {
        if shouldReturnError {
            throw errorToThrow
        }
        return productsToReturn
    }
    
    func addNewCart(cart: Cart) async throws -> Cart {
        fatalError("Not needed for FeedViewModel tests")
    }
}

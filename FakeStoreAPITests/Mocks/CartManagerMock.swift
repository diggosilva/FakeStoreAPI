//
//  CartManagerMock.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 06/02/26.
//

@testable import FakeStoreAPI

final class CartManagerMock: CartManaging {
    
    private(set) var addedProducts: [Product] = []
    
    func add(_ product: Product) {
        addedProducts.append(product)
    }
    
    func contains(_ product: Product) -> Bool {
        addedProducts.contains(product)
    }
}

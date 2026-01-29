//
//  CartManager.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 28/01/26.
//

import Foundation

final class CartManager {
    
    static let shared = CartManager()
    private(set) var items: [CartProduct] = []
    
    private init() {}
    
    func addItem(productId: Int, quantity: Int) {
        if let index = items.firstIndex(where: { $0.productId == productId }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartProduct(productId: productId, quantity: quantity)
            items.append(newItem)
        }
    }
    
    func totalItems() -> Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
}

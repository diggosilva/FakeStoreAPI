//
//  CartViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 30/01/26.
//

import Foundation
import Combine

protocol CartViewModelProtocol {
    func removeItem(at index: Int)
}

final class CartViewModel: CartViewModelProtocol {
    
    @Published private(set) var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    init() {
        bindCart()
    }
    
    private func bindCart() {
        CartManager.shared.$items
            .assign(to: &$items)
    }
    
    func removeItem(at index: Int) {
        let productID = items[index].product.id
        CartManager.shared.removeAllItems(of: productID)
    }
}

//
//  ProductDetailViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 26/01/26.
//

import Foundation

@MainActor
protocol ProductDetailViewModelProtocol {
    func updateProduct() -> Product
    func addToCart() async throws
}

@MainActor
final class ProductDetailViewModel: ProductDetailViewModelProtocol {
    
    private var product: Product
    private var service: ServiceProtocol
    private var cartManager: CartManaging
        
    init(product: Product, service: ServiceProtocol = Service(), cartManager: CartManaging = CartManager.shared) {
        self.product = product
        self.service = service
        self.cartManager = cartManager
    }
    
    func updateProduct() -> Product {
        product
    }
    
    func addToCart() async throws {
        cartManager.add(product)
    }
}

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
        
    init(product: Product, service: ServiceProtocol = Service()) {
        self.product = product
        self.service = service
    }
    
    func updateProduct() -> Product {
        return product
    }
    
    func addToCart() async throws {
        try await service.postCart(productId: product.id, quantity: 1)
        
        CartManager.shared.addItem(productId: product.id, quantity: 1)
    }
}

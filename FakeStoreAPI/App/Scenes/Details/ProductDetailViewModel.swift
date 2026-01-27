//
//  ProductDetailViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 26/01/26.
//

import Foundation

protocol ProductDetailViewModelProtocol {
    func updateProduct() -> Product
}

final class ProductDetailViewModel: ProductDetailViewModelProtocol {
    
    private var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func updateProduct() -> Product {
        return product
    }
}

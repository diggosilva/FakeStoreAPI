//
//  Product.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let descriptionProduct: String
    let category: CategoryProduct
    let image: String
    
    init(from response: ProductResponse) {
        self.id = response.id
        self.title = response.title
        self.price = response.price
        self.descriptionProduct = response.description
        self.category = CategoryProduct(rawValue: response.category.rawValue) ?? .unknown
        self.image = response.image
    }
}

enum CategoryProduct: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
    case unknown = "unknown"
}

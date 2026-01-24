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
    let category: Category
    let image: String
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
    case unknown = "unknown"
}

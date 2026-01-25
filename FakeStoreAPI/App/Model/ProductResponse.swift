//
//  ProductResponse.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import Foundation

struct ProductResponse: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: CategoryResponse
    let image: String
    let rating: Rating
    
    enum CategoryResponse: String, Codable {
        case electronics = "electronics"
        case jewelery = "jewelery"
        case menSClothing = "men's clothing"
        case womenSClothing = "women's clothing"
    }
    
    // MARK: - Rating
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}

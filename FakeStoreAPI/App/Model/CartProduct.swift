//
//  CartProduct.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 27/01/26.
//

import Foundation

struct CartProduct: Codable {
    var productId: Int
    var quantity: Int
}

struct Cart: Codable {
    var userId: Int?
    var date: String
    var products: [CartProduct]
}

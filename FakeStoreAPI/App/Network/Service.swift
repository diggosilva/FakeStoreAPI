//
//  Service.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodeError
}

protocol ServiceProtocol: AnyObject {
    func getProducts() async throws -> [Product]
}

final class Service: ServiceProtocol {
    func getProducts() async throws -> [Product] {
        let urlString = "https://fakestoreapi.com/products"
        
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ServiceError.invalidResponse }
        
        let productResponse = try JSONDecoder().decode([ProductResponse].self, from: data)
        
        let products = productResponse.map { Product(from: $0) }
        
        return products
    }
}

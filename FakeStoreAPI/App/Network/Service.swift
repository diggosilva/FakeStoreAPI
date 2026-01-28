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
    func postCart(productId: Int, quantity: Int) async throws
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
    
    func postCart(productId: Int, quantity: Int) async throws {
        let urlString = "https://fakestoreapi.com/carts"
        
        guard let url = URL(string: urlString) else { throw ServiceError.invalidURL }
        
        let cart = Cart(userId: 1, date: Date().now, products: [CartProduct(productId: productId, quantity: quantity)])
        
        let jsonData = try JSONEncoder().encode(cart)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("STATUS CODE: \(httpResponse.statusCode)")
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw ServiceError.invalidResponse
            }
            
            if let reply = String(data: data, encoding: .utf8) {
                print("Resposta do servidor: \(reply)")
            }
        }
    }
}

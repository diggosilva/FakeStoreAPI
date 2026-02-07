//
//  CartManager.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 29/01/26.
//

import Foundation
import Combine

protocol CartManaging {
    func add(_ product: Product)
    func contains(_ product: Product) -> Bool
}

struct CartItem: Codable {
    let product: Product
    var quantity: Int
}

final class CartManager {

    // MARK: - Singleton
    static let shared = CartManager()

    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private let cartKey = "cartKey"

    @Published private(set) var items: [CartItem] = [] {
        didSet {
            saveCart()
        }
    }

    // MARK: - Computed Properties
    var totalItemsCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    // MARK: - Initializer
    private init() {
        self.items = loadCart()
    }

    // MARK: - Persistence
    private func saveCart() {
        guard let encoded = try? JSONEncoder().encode(items) else { return }
        userDefaults.set(encoded, forKey: cartKey)
    }

    private func loadCart() -> [CartItem] {
        guard let data = userDefaults.data(forKey: cartKey),
              let decoded = try? JSONDecoder().decode([CartItem].self, from: data) else {
            return []
        }
        return decoded
    }

    // MARK: - Cart Actions
    func add(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func removeOneItem(productID: Int) {
        guard let index = items.firstIndex(where: { $0.product.id == productID }) else { return }

        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func removeAllItems(of productID: Int) {
        items.removeAll { $0.product.id == productID }
    }

    func clearCart() {
        items.removeAll()
    }
}

// MARK: - CartManaging Conformance
extension CartManager: CartManaging {
    func contains(_ product: Product) -> Bool {
        items.contains { $0.product.id == product.id }
    }
}

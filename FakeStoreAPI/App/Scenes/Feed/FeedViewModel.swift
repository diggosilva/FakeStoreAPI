//
//  FeedViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import Foundation
import Combine

enum FeedVCStates {
    case idle
    case loading
    case loaded
    case error(String)
}

@MainActor
protocol FeedViewModelProtocol: AnyObject, StatefulViewModel where State == FeedVCStates {
    func numberOfRows() -> Int
    func productForRow(at index: Int) -> Product
    func fetchProducts() async
    func search(text: String)
}

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    private let service: ServiceProtocol
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    private var currentSearchText: String = ""
    
    private let stateSubject = CurrentValueSubject<FeedVCStates, Never>(.idle)
    
    var statePublisher: AnyPublisher<FeedVCStates, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func numberOfRows() -> Int {
        return filteredProducts.count
    }
    
    func productForRow(at index: Int) -> Product {
        return filteredProducts[index]
    }
    
    func fetchProducts() async {
        stateSubject.send(.loading)
        
        do {
            products = try await service.getProducts()
            filteredProducts = products
            stateSubject.send(.loaded)
        } catch {
            stateSubject.send(.error("Ocorreu um erro ao carregar os produtos. \(error.localizedDescription)"))
        }
    }
    
    func search(text: String) {
        currentSearchText = normalize(text)
        applyFilter()
    }
    
    private func normalize(_ text: String) -> String {
        return text
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func applyFilter() {
        if currentSearchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                normalize($0.title).contains(currentSearchText) ||
                normalize($0.category.rawValue).contains(currentSearchText)
            }
        }
    }
}

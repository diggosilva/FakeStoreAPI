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
//    var isLoading: Bool { get set }
//    var onResult: (() -> Void)? { get set }
//    var errorMessage: String? { get set }
    
    func numberOfRows() -> Int
    func productForRow(at index: Int) -> Product
    func fetchProducts() async
}

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    private let service: ServiceProtocol
    private var products: [Product] = []
    
    private let stateSubject = CurrentValueSubject<FeedVCStates, Never>(.idle)
    
    var statePublisher: AnyPublisher<FeedVCStates, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
//    var isLoading: Bool = false
//    var onResult: (() -> Void)?
//    var errorMessage: String? = nil
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func numberOfRows() -> Int {
        return products.count
    }
    
    func productForRow(at index: Int) -> Product {
        return products[index]
    }
    
//    func fetchProducts() async {
//        updateLoading(true)
//        
//        do {
//            products = try await service.getProducts()
//            updateLoading(false)
//        } catch {
//            errorMessage = "Ocorreu um erro ao carregar os produtos. \(error.localizedDescription)"
//            updateLoading(false)
//        }
//    }
    
    func fetchProducts() async {
        stateSubject.send(.loading)
        
        do {
            products = try await service.getProducts()
            stateSubject.send(.loaded)
        } catch {
            stateSubject.send(.error("Ocorreu um erro ao carregar os produtos. \(error.localizedDescription)"))
        }
    }
    
//    private func updateLoading(_ loading: Bool) {
//        if loading { self.errorMessage = nil }
//        isLoading = loading
//        onResult?()
//    }
}

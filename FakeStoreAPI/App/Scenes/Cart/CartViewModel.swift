//
//  CartViewModel.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 30/01/26.
//

import Foundation
import Combine

enum CartStates {
    case idle
    case loading
    case loaded
    case error(String)
}

@MainActor
protocol CartViewModelProtocol: StatefulViewModel where State == CartStates {
    var items: [CartItem] { get }
    var totalPrice: Double { get }
    func removeItem(at index: Int)
    func incrementItem(id: Int)
    func decrementItem(id: Int)
    func checkout() async
}

final class CartViewModel: CartViewModelProtocol {
    
    private let service: ServiceProtocol
    private let stateSubject = CurrentValueSubject<CartStates, Never>(.idle)
    
    var statePublisher: AnyPublisher<CartStates, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    @Published private(set) var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
        bindCart()
    }
    
    private func bindCart() {
        CartManager.shared.$items
            .assign(to: &$items)
    }
    
    func removeItem(at index: Int) {
        let productID = items[index].product.id
        CartManager.shared.removeAllItems(of: productID)
    }
    
    func incrementItem(id: Int) {
        if let product = items.first(where: { $0.product.id == id })?.product {
            CartManager.shared.add(product)
        }
    }
    
    func decrementItem(id: Int) {
        CartManager.shared.removeOneItem(productID: id)
    }
    
    func checkout() async {
        guard !items.isEmpty else {
            stateSubject.send(.error("Seu carrinho está vazio. Adicione produtos antes de finalizar!"))
            return
        }
        
        stateSubject.send(.loading)
        
        // Mapeia nossos itens para o formato que a FakeStoreAPI espera (CartProduct)
        let cartProducts = items.map { CartProduct(productId: $0.product.id, quantity: $0.quantity) }
        
        // Criamos o objeto Cart (usando ID 1 como usuário padrão)
        let cartToSend = Cart(userId: 1, date: Date().now, products: cartProducts)
        
        do {
            // Chamada de rede
            _ = try await service.addNewCart(cart: cartToSend)
            
            // Sucesso: Limpamos o carrinho local e avisamos a View
            CartManager.shared.clearCart()
            stateSubject.send(.loaded)
            
        } catch {
            // Erro: Avisamos a View com a mensagem tratada
            print("DEBUG: Erro no checkout: \(error)")
            stateSubject.send(.error("Ocorreu um erro ao finalizar a compra. Tente novamente."))
        }
    }
}

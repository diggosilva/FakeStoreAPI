//
//  MainTabBarController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 28/01/26.
//

import UIKit
import Combine

final class MainTabBarController: UITabBarController {
    
    private let vc1 = UINavigationController(rootViewController: FeedViewController())
    private let vc2 = UINavigationController(rootViewController: CartViewController())
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        observeCart()
    }
    
    func setup() {
        vc1.tabBarItem.title = "Loja"
        vc1.tabBarItem.image = UIImage(systemName: "bag")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "bag.fill")
        
        vc2.tabBarItem.title = "Carrinho"
        vc2.tabBarItem.image = UIImage(systemName: "cart")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        
        viewControllers = [vc1, vc2]
    }
    
    private func observeCart() {
        CartManager.shared.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let count = CartManager.shared.totalItemsCount
                self.vc2.tabBarItem.badgeValue = count > 0 ? "\(count)" : nil
            }.store(in: &cancellables)
    }
}

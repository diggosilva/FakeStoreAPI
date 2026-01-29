//
//  MainTabBarController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 28/01/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let vc1 = UINavigationController(rootViewController: FeedViewController())
    private let vc2 = UINavigationController(rootViewController: CartViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    func updateBadge() {
        let total = CartManager.shared.totalItems()
        
        if let cartItem = tabBar.items?.last {
            // Se total for 0, atribui nil (some). Se não, atribui a String do total.
            cartItem.badgeValue = (total > 0) ? "\(total)" : nil
        }
    }
}

class CartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Carrinho"
    }
}

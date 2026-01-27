//
//  ProductDetailViewController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 26/01/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private let contentView = ProductDetailView()
    private let viewModel: ProductDetailViewModelProtocol
    
    init(viewModel: ProductDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        bindViewModel()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Detalhes do Produto"
    }
    
    private func bindViewModel() {
        let product = viewModel.updateProduct()
        contentView.configure(product: product)
    }
}

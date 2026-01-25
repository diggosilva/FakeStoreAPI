//
//  ViewController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 24/01/26.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private let viewModel: any FeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ServiceProtocol = Service()) {
        self.viewModel = FeedViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        handleStates()
        fetchProducts()
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle: break
                case .loading: showLoadingState()
                case .loaded: showLoadedState()
                case .error(let error): showErrorState(message: error)
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        print("CARREGANDO...")
    }
    
    private func showLoadedState() {
        print("CARREGADO!!!")
        for i in 0..<viewModel.numberOfRows() {
            let product = viewModel.productForRow(at: i)
            print("ID: \(product.id), Nome: \(product.title)")
        }
    }
    
    private func showErrorState(message: String) {
        showErrorAlert(message: message)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func fetchProducts() {
        Task { await viewModel.fetchProducts() }
    }
}

//
//  CartViewController.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 29/01/26.
//

import UIKit
import Combine

class CartViewController: UIViewController {
    
    private let contentView = CartView()
    private let viewModel = CartViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Meu Carrinho"
        setupTableView()
        bindViewModel()
        handleStates()
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.delegate = self
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .idle: break
                case .loading: self?.showLoadingState()
                case .loaded: self?.showLoadedState()
                case .error(let error): self?.showErrorState(message: error)
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        updateButtonState(true)
    }
    
    private func showLoadedState() {
        updateButtonState(false)
        showAlert(title: "Sucesso ✅", message: "Sua compra foi finalizada!")
    }
    
    private func showErrorState(message: String) {
        updateButtonState(false)
        showErrorAlert(message: message)
    }
    
    private func updateButtonState(_ isLoading: Bool) {
        if isLoading {
            contentView.spinner.startAnimating()
            contentView.checkoutButton.isEnabled = false
            contentView.checkoutButton.alpha = 0.5
        } else {
            contentView.spinner.stopAnimating()
            contentView.checkoutButton.isEnabled = true
            contentView.checkoutButton.alpha = 1.0
        }
    }
    
    private func bindViewModel() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.contentView.tableView.reloadData()
                self?.updateTotal()
            }.store(in: &cancellables)
    }
    
    private func updateTotal() {
        contentView.totalLabel.text = "Total: \(viewModel.totalPrice.formattedCurrency(for: Locale(identifier: "en_US")))"
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else { return UITableViewCell() }
        let item = viewModel.items[indexPath.row]
        cell.delegate = self
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CartViewController: CartCellDelegate {
    func didTapIncrement(id: Int) {
        viewModel.incrementItem(id: id)
    }
    
    func didTapDecrement(id: Int) {
        viewModel.decrementItem(id: id)
    }
}

extension CartViewController: CartViewDelegate {
    func didTapCheckout() {
        Task { await viewModel.checkout() }
    }
}

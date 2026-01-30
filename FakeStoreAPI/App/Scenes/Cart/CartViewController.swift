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
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
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

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        let item = viewModel.items[indexPath.row]
        cell.textLabel?.text = "\(item.quantity)x \(item.product.title)"
        cell.detailTextLabel?.text = item.product.price.formattedCurrency()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
        }
    }
}

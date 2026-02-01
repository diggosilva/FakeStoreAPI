//
//  CartView.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 30/01/26.
//

import UIKit

protocol CartViewDelegate: AnyObject {
    func didTapCheckout()
}

final class CartView: UIView {
    
    weak var delegate: CartViewDelegate?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        return tv
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    lazy var checkoutButton: UIButton = {
        CustomButton(image: UIImage(systemName: "cart"), title: "Finalizar Compra", target: self, action: #selector(didTapCheckout))
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfigurations()
    }
    
    private func setupHierarchy() {
        addSubviews(tableView, totalLabel, checkoutButton, spinner)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -8),
            
            checkoutButton.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: totalLabel.trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupConfigurations() {
        backgroundColor = .systemBackground
    }
    
    @objc private func didTapCheckout() {
        delegate?.didTapCheckout()
    }
}

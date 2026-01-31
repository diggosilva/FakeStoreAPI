//
//  CartView.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 30/01/26.
//

import UIKit

final class CartView: UIView {
    
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
        addSubviews(tableView, totalLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupConfigurations() {
        backgroundColor = .systemBackground
    }
}

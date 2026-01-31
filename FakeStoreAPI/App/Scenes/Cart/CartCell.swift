//
//  CartCell.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 30/01/26.
//

import UIKit
import SDWebImage

protocol CartCellDelegate: AnyObject {
    func didTapIncrement(id: Int)
    func didTapDecrement(id: Int)
}

final class CartCell: UITableViewCell {
    
    static let identifier = "CartCell"
    weak var delegate: CartCellDelegate?
    private var productID: Int?
    
    lazy var productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(tapDecrement), for: .touchUpInside)
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(tapIncrement), for: .touchUpInside)
        return button
    }()
    
    private lazy var stepperStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfigurations()
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(productImageView, titleLabel, priceLabel, stepperStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: stepperStack.leadingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stepperStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepperStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stepperStack.widthAnchor.constraint(equalToConstant: 100),
        ])
        stepperStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configure(with item: CartItem) {
        self.productID = item.product.id
        titleLabel.text = item.product.title
        priceLabel.text = item.product.price.formattedCurrency(for: Locale(identifier: "en_US"))
        quantityLabel.text = "\(item.quantity)"
        productImageView.sd_setImage(with: URL(string: item.product.image))
    }
    
    private func setupConfigurations() {
        backgroundColor = .secondarySystemGroupedBackground
    }
    
    @objc private func tapDecrement() {
        if let id = productID { delegate?.didTapDecrement(id: id) }
    }
    
    @objc private func tapIncrement() {
        if let id = productID { delegate?.didTapIncrement(id: id) }
    }
}

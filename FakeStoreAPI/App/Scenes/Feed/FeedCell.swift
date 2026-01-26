//
//  FeedCell.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 25/01/26.
//

import UIKit
import SDWebImage

final class FeedCell: UITableViewCell {
    
    static let identifier = "FeedCell"
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubviews(productImageView, titleLabel, categoryLabel, priceLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container - Dá o espaçamento entre as células (margem)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor),
            
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            priceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor)
        ])
    }
    
    func setupConfigurations() {
        selectionStyle = .none
        backgroundColor = .clear
    }
        
    func configure(with product: Product) {
        guard let url = URL(string: product.image) else { return }
        
        productImageView.sd_setImage(with: url)
        titleLabel.text = product.title
        categoryLabel.text = product.category.rawValue.uppercased()
        priceLabel.text = product.price.formattedCurrency(for: Locale(identifier: "en_US"))
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        categoryLabel.text = nil
        priceLabel.text = nil
        productImageView.image = nil
    }
}

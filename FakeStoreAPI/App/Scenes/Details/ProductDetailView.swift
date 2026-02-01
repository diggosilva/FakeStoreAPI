//
//  ProductDetailView.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 26/01/26.
//

import UIKit
import SDWebImage

protocol ProductDetailViewDelegate: AnyObject {
    func didTapAddToCart()
}

final class ProductDetailView: UIView {
    
    weak var delegate: ProductDetailViewDelegate?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.textColor = .systemGreen
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, priceLabel, titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var addToCartButton: UIButton = {
        CustomButton(image: UIImage(systemName: "cart"), title: "Adicionar ao Carrinho", target: self, action: #selector(didTapAddToCart))
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
        addSubview(scrollView)
        addSubview(addToCartButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -10),
            
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addToCartButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addToCartButton.heightAnchor.constraint(equalToConstant: 44),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            productImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc private func didTapAddToCart() {
        delegate?.didTapAddToCart()
    }
    
    func configure(product: Product) {
        guard let url = URL(string: product.image) else { return }
        
        productImageView.sd_setImage(with: url)
        descriptionLabel.text = product.descriptionProduct
        priceLabel.text = product.price.formattedCurrency(for: Locale(identifier: "en_US"))
        titleLabel.text = product.title
    }
    
    private func setupConfigurations() {
        backgroundColor = .systemBackground
    }
}

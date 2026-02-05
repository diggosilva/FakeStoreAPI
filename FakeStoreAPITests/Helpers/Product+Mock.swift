//
//  Product+Mock.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 05/02/26.
//

@testable import FakeStoreAPI

extension Product {

    static func mock(
        id: Int = 1,
        title: String = "Mock Product",
        price: Double = 10.0,
        descriptionProduct: String = "Mock description",
        category: CategoryProduct = .electronics,
        image: String = ""
    ) -> Product {

        let responseCategory: ProductResponse.CategoryResponse = {
            switch category {
            case .electronics: return .electronics
            case .jewelery: return .jewelery
            case .menSClothing: return .menSClothing
            case .womenSClothing: return .womenSClothing
            case .unknown: return .electronics
            }
        }()

        let response = ProductResponse(
            id: id,
            title: title,
            price: price,
            description: descriptionProduct,
            category: responseCategory,
            image: image,
            rating: ProductResponse.Rating(rate: 3.0, count: 2)
        )

        return Product(from: response)
    }
}

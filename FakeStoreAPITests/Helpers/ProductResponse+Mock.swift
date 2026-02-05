//
//  ProductResponse+Mock.swift
//  FakeStoreAPITests
//
//  Created by Diggo Silva on 05/02/26.
//

@testable import FakeStoreAPI

extension ProductResponse {

    static func mock(
        id: Int = 1,
        title: String = "Mock Product",
        price: Double = 10.0,
        description: String = "Mock description",
        category: CategoryResponse = .electronics,
        image: String = ""
    ) -> ProductResponse {
        ProductResponse(
            id: id,
            title: title,
            price: price,
            description: description,
            category: category,
            image: image, rating: Rating(rate: 3.0, count: 2)
        )
    }
}

//
//  Date+Extensions.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 27/01/26.
//

import Foundation

extension Date {
    var now: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

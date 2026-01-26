//
//  Double+Extensions.swift
//  FakeStoreAPI
//
//  Created by Diggo Silva on 25/01/26.
//

import Foundation

extension Double {    
    func formattedCurrency(for locale: Locale? = nil) -> String {
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.usesGroupingSeparator = true
         formatter.locale = locale ?? Locale.current
         return formatter.string(for: self) ?? ""
     }
}

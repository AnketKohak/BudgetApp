//
//  Locale+Extesnsion.swift
//  BudgetApp
//
//  Created by Anket Kohak on 28/01/25.
//

import Foundation
extension Locale {
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}

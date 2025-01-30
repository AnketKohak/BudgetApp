//
//  Expense+Extension.swift
//  BudgetApp
//
//  Created by Anket Kohak on 30/01/25.
//

import Foundation
import CoreData

extension Expense{
    var total: Double{
        amount * Double(quantity)
    }
}

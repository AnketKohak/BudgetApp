//
//  BudgetCellView.swift
//  BudgetApp
//
//  Created by Anket Kohak on 27/01/25.
//

import Foundation
import SwiftUI

struct BudgetCellView: View {
    let budget: Budget
    var body: some View {
        HStack{
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit , format: .currency(code: Locale.currencyCode))
        }
    }
}


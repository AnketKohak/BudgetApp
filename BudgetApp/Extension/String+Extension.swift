//
//  String+Extension.swift
//  BudgetApp
//
//  Created by Anket Kohak on 25/01/25.
//

import Foundation

extension String{
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}

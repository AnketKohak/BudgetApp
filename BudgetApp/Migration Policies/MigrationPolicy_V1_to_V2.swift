//
//  MigrationPolicy_V1_to_V2.swift
//  BudgetApp
//
//  Created by Anket Kohak on 30/01/25.
//

import Foundation
import CoreData

class MigrationPolicy_V1_to_V2: NSEntityMigrationPolicy {
    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        var titles: [String] = []
        var index: Int = 1
        
        let context = manager.sourceContext
        let expenseRequest = Expense.fetchRequest()
        
        let results: [NSManagedObject] = try context.fetch(expenseRequest)
        
        for result in results{
            guard let title = result.value(forKey: "title") as? String else { continue }
            if !titles.contains(title) {
                titles.append(title)
            }else{
                let uniqueTitle = title + "\(index)"
                index += 1
                result.setValue(uniqueTitle, forKey: "title")
            }
        }
    }
}
 

//
//  Budget_Extension.swift
//  BudgetApp
//
//  Created by Anket Kohak on 25/01/25.
//

import Foundation
import CoreData

extension Budget{
    static func exists(context: NSManagedObjectContext,title: String)->Bool{
        
        let request = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        do{
            let results = try context.fetch(request)
            return !results.isEmpty
        }catch{
            return false
        }
    }
}

//
//  CoreDataProvider.swift
//  BudgetApp
//
//  Created by Anket Kohak on 25/01/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Preview
    static var preview: CoreDataProvider{
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context
        
       
        let groceries = Budget(context: context)
        groceries.title = "Groceries"
        groceries.limit = 300
        groceries.dateCreated = Date()
        
        let milk = Expense(context: context)
        milk.title = "Milk"
        milk.amount = 10
        milk.dateCreated = Date()
        groceries.addToExpenses(milk)
        let cookie = Expense(context: context)
        cookie.title = "Cookie"
        cookie.amount = 25
        cookie.dateCreated = Date()
        groceries.addToExpenses(cookie)

        
        
        
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        return provider
    }
    
    init(inMemory: Bool = false){
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error{
                fatalError("Core Data store failed to initialize: \(error)")
            }
        }
    }
}

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
        
        let entertainment = Budget(context: context)
        entertainment.title = "Entertainment"
        entertainment.limit = 500
        entertainment.dateCreated = Date()
        
        let groceries = Budget(context: context)
        groceries.title = "Groceries"
        groceries.limit = 300
        groceries.dateCreated = Date()

        let transportation = Budget(context: context)
        transportation.title = "Transportation"
        transportation.limit = 200
        transportation.dateCreated = Date()

        let healthcare = Budget(context: context)
        healthcare.title = "Healthcare"
        healthcare.limit = 800
        healthcare.dateCreated = Date()

        let education = Budget(context: context)
        education.title = "Education"
        education.limit = 1000
        education.dateCreated = Date()
        
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

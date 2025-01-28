//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Anket Kohak on 25/01/25.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    let provider : CoreDataProvider
    let tagsSeeder: TagsSeeder
    init() {
        provider = CoreDataProvider()
        tagsSeeder = TagsSeeder(context: provider.context)
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                BudgetListScreen()
                    .onAppear{
                        let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeededData")
                        if !hasSeededData{
                            let commonTags = ["Food", "Travel", "Entertainment", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
                            do{
                                try tagsSeeder.seed(commonTags)
                                UserDefaults.standard.set(true, forKey: "hasSeededData")
                            }catch{
                                print(error)
                            }
                        }
                    }
            }  .environment(\.managedObjectContext, provider.context)
        }
    }
}

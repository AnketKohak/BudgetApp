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
    init() {
        provider = CoreDataProvider()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                BudgetListScreen()
                  
            }  .environment(\.managedObjectContext, provider.context)
        }
    }
}

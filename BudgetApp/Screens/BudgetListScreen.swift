//
//  BudgetListScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 25/01/25.
//

import SwiftUI

struct BudgetListScreen: View {
    @FetchRequest(sortDescriptors: []) private var budgets:FetchedResults<Budget>
    
    @State private var isPresnted: Bool = false
    var body: some View {
        VStack{
            List(budgets){ budget in
                NavigationLink{
                    BudgetDetailScreen(budget: budget)
                }label:{
                    BudgetCellView(budget: budget)
                }
                
            }
        }.navigationTitle("Budget App")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Budget"){
                        isPresnted = true
                    }
                }
            }.sheet(isPresented: $isPresnted, content: {
                AddBudgetScreen()
            })
        
    }
}

#Preview {
    NavigationStack{
        BudgetListScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}


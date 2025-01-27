//
//  BudgetDetailScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 27/01/25.
//

import SwiftUI

struct BudgetDetailScreen: View {
    let budget: Budget
    @Environment(\.managedObjectContext) private var context
    @State private var title: String = ""
    @State private var amount: Double?
    private var isFormValid :Bool{
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!)>0
    }
    private func addExpense(){
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.dateCreated = Date()
        budget.addToExpenses(expense)
        do{
            try context.save()
            title = ""
            amount = nil
        }catch{
            print(error.localizedDescription)
        }
    }
    var body: some View {
        Form{
            Section("New expense"){
                TextField("Title",text: $title)
                TextField("Amount", value:$amount ,format:  .number)
                    .keyboardType(.numberPad)
                
                Button{
                    addExpense()
                }label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
            }
            
        }.navigationTitle(budget.title ?? "")
    }
}

struct BudgetDetailScreenContainer: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    var body: some View {
        BudgetDetailScreen(budget: budgets[0])
    }
}


#Preview {
    NavigationStack{
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

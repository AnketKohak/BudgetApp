//
//  BudgetDetailScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 27/01/25.
//

import SwiftUI

struct BudgetDetailScreen: View {
    // MARK: - Variables
    let budget: Budget
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    @Environment(\.managedObjectContext) private var context

    @State private var title: String = ""
    @State private var amount: Double?
    @State private var selectedTags: Set<Tag> = []
    @State private var quantity: Int?
    
    // MARK: Init
    init(budget: Budget){
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [],predicate: NSPredicate(format: "budget == %@" ,budget))
        
    }
   
    // MARK: - DataRealated
    private func addExpense(){
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        budget.addToExpenses(expense)
        do{
            try context.save()
            title = ""
            amount = nil
        }catch{
            print(error.localizedDescription)
        }
    }
    private func deleteExpense(_ indexSet: IndexSet){
        indexSet.forEach{ index in
            let expense = expenses[index]
            context.delete(expense)
        }
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    private var isFormValid :Bool{
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!)>0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
        
    }
    // MARK: - Body
    var body: some View {
        VStack {
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
        }
        Form{
            Section("New expense"){
                // MARK: -Textfields
                TextField("Title",text: $title)
                TextField("Amount", value:$amount ,format:  .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value:$quantity ,format:  .number)
                    .keyboardType(.numberPad)
                TagsView(selectedTags: $selectedTags)
                // MARK: -Button
                Button(action: {
                    addExpense()
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
            Section("Expense"){
                List{
                    VStack{
                        HStack {
                            Spacer()
                            Text("Spent")
                            Text(budget.spent,format: .currency(code: Locale.currencyCode ))
                            Spacer()
                            
                        }
                        HStack {
                            Spacer()
                            Text("Reamaining")
                            Text(budget.reamaining,format: .currency(code: Locale.currencyCode ))
                                .foregroundStyle(budget.reamaining < 0 ? .red:.green)
                            Spacer()
                            
                        }
                    }
                    ForEach(expenses){ expense in
                        ExpenseCellView(expense: expense)
                    }.onDelete(perform: deleteExpense)
                    
                }
            }
        }.navigationTitle(budget.title ?? "")
    }
}

struct BudgetDetailScreenContainer: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    var body: some View {
        BudgetDetailScreen(budget: budgets.first(where: {$0.title == "Groceries"})!)
    }
}


#Preview {
    NavigationStack{
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}


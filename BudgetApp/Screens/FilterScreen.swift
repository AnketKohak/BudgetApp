//
//  FilterScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 28/01/25.
//

import SwiftUI

struct FilterScreen: View {
    // MARK: - Varibles
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var selectedTags: Set<Tag> = []
    @State private var filterdExpenses: [Expense] = []
    @State private var showAll: Bool = false
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    
    
    // MARK: - functions
    private func filterTags(){
        if selectedTags.isEmpty{
            return
        }
        let selectedTagName = selectedTags.map{$0.name}
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagName)
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    private func filterByPrice(){
        guard let startPrice = startPrice, let endPrice = endPrice else {
            return
        }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice),
                                        NSNumber(value: endPrice))
        
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading){ //parent stack
            // MARK: Tags
            Section("Filter by Tags"){
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags,filterTags)
            }
            Section("Filter By Price"){
                HStack{
                    TextField("Start Price", value: $startPrice, format: .number)
                        .textFieldStyle(.roundedBorder)
                    TextField("End Price", value: $endPrice, format: .number)
                        .textFieldStyle(.roundedBorder)

                    Button("Search"){
                        filterByPrice()
                    }
                }
            }
            // MARK: Display
            List(filterdExpenses){ expense in
                ExpenseCellView(expense: expense)
            }
            Spacer()
            HStack{
                Spacer()
                // MARK: ShowAll
                Button("Show All"){
                    selectedTags = []
                    filterdExpenses = expenses.map{$0}
                }
                Spacer()
            }
        }.onChange(of: showAll, initial: false,{
            print("onChange")
            showAll = false
        })
        .padding()
        .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack{
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

//
//  FilterScreen.swift
//  BudgetApp
//
//  Created by Anket Kohak on 28/01/25.
//

import SwiftUI

struct FilterScreen: View {
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    @State private var filterdExpenses: [Expense] = []
    private func filterTags(){
        let selectedTagName = selectedTags.map{$0.name}
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagName)
        do{
            filterdExpenses = try context.fetch(request)
        }catch{
            print(error)
        }
        
    }
    var body: some View {
        VStack{
            TagsView(selectedTags: $selectedTags)
                .onChange(of: selectedTags,filterTags)
            List(filterdExpenses){ expense in
                ExpenseCellView(expense: expense)
            }
            Spacer()
        }.padding()
            .navigationTitle("Filter")
    }
}

#Preview {
    NavigationStack{
        FilterScreen()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

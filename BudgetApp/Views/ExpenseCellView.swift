//
//  ExpenseCellView.swift
//  BudgetApp
//
//  Created by Anket Kohak on 28/01/25.
//

import SwiftUI
struct ExpenseCellView: View {
    @ObservedObject var expense: Expense
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(expense.title ?? "")
                Text("\(expense.quantity)")
                Spacer()
                Text(expense.total , format: .currency(code: Locale.currencyCode))
                
            }.contentShape(Rectangle())
            ScrollView(.horizontal){
                HStack{
                    ForEach(Array(expense.tags as? Set<Tag> ?? [])){ tag in
                        Text(tag.name ?? "")
                            .font(.caption)
                            .padding(6)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style:. continuous))
                    }
                }
            }
        }
    }
}

struct ExpenseCellViewContainer:View {
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    var body: some View {
        ExpenseCellView(expense: expenses[0])
    }
}


#Preview {
    ExpenseCellViewContainer()
        .environment(\.managedObjectContext,CoreDataProvider.preview.context)
}
